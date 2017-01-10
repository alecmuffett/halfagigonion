#!/usr/bin/env python

import time
import os

oldcache = {}
diffcache = {}

stats = {
    '/sys/class/thermal/thermal_zone0/temp': 'temp',
    '/proc/sys/kernel/random/entropy_avail': 'entropy',
}

counters = {
    '/sys/class/net/eth0/statistics/rx_bytes': 'eth0:rxb',
    '/sys/class/net/eth0/statistics/rx_packets': 'eth0:rxp',
    '/sys/class/net/eth0/statistics/tx_bytes': 'eth0:txb',
    '/sys/class/net/eth0/statistics/tx_packets': 'eth0:txp',

    '/sys/class/net/eth1/statistics/rx_bytes': 'eth1:rxb',
    '/sys/class/net/eth1/statistics/rx_packets': 'eth1:rxp',
    '/sys/class/net/eth1/statistics/tx_bytes': 'eth1:txb',
    '/sys/class/net/eth1/statistics/tx_packets': 'eth1:txp',

    '/sys/class/net/wlan0/statistics/rx_bytes': 'wlan0:rxb',
    '/sys/class/net/wlan0/statistics/rx_packets': 'wlan0:rxp',
    '/sys/class/net/wlan0/statistics/tx_bytes': 'wlan0:txb',
    '/sys/class/net/wlan0/statistics/tx_packets': 'wlan0:txp',
}

analysis = {
    '/sys/class/net/eth0/statistics/rx_bytes': 'ETH0:RX',
    '/sys/class/net/eth0/statistics/tx_bytes': 'ETH0:TX',
    '/sys/class/net/eth1/statistics/rx_bytes': 'ETH1:RX',
    '/sys/class/net/eth1/statistics/tx_bytes': 'ETH1:TX',
}

# open a file, read an ascii integer
def get_stat(filename):
    with open(filename) as f:
	x = f.readline()
	return int(x)

# rpi kernel is 32-bit, we have to compensate for counters rolling over
def get_counter(filename):
    old = oldcache.get(filename, 0)
    new = get_stat(filename)
    diff = new - old
    # imagine we had to do this mod-10, ie: maxval=9
    # say: old=8 new=2[rolled over] => diff=-6
    # thus: actual diff=(maxval[9] - old[8]) + new[2] + 1 = 4
    # because old[8] + 4 = 12 = 2 mod 10
    # assume no double-rollovers because stupid
    if diff < 0:
	diff = (4294967295L - old) + new + 1
    oldcache[filename] = new
    diffcache[filename] = diff
    return diff

# ------------------------------------------------------------------

for k, v in stats.items(): # not iteritems() because deletion
    if not os.path.isfile(k):
	print "eliding", v
	del stats[k]

for k, v in counters.items(): # not iteritems() because deletion
    if not os.path.isfile(k):
	print "eliding", v
	del counters[k]

for k, v in analysis.items(): # not iteritems() because deletion
    if not os.path.isfile(k):
	print "eliding", v
	del analysis[k]

previously = None
coarse_sleep = 10.0

while True:
    now = time.time()
    buffer = []

    for k, v in stats.iteritems():
	i = get_stat(k)
	buffer.append("%s=%d" % (v, i))

    for k, v in counters.iteritems():
	i = get_counter(k)
	buffer.append("%s=%d" % (v, i))

    if previously != None: # we have tripped the loop once?
	for k, v in analysis.iteritems():
	    nbytes = diffcache[k]
	    tdiff = now - previously
	    bps = int(nbytes / tdiff)
	    buffer.append("%s=%d" % (v, bps))
	print ("%f" % now), " ".join(buffer)

    # remember `now`
    previously = now

    # delay; try to align roughly onto boundaries
    nownow = time.time()
    when = int((nownow + coarse_sleep + 1.0) / coarse_sleep) * coarse_sleep
    time.sleep(when - nownow)
