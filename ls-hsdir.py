#!/usr/bin/env python

from stem.control import Controller
from time import gmtime, strftime
import datetime
import stem
import sys

now = datetime.datetime.utcnow()
now2 = now.strftime('%Y-%m-%d %H:%M:%S')

def print_hsdir(controller, name):
    try:
        x = controller.get_hidden_service_descriptor(name)
    except stem.DescriptorUnavailable:
        print "# unavailable", name
        return

    ips = sorted([ "%s:%d" % (ip.address, ip.port) for ip in x.introduction_points()])
    age = now - x.published

    print "v=%d age=%d nip=%d pub(%s) now(%s) %s" % (
        x.version,
        age.total_seconds(),
        len(ips),
        x.published,
        now2,
        name
    )

    i = 0
    for ip in ips:
        print "\t%d: %s" % (i, ip)
        i = i + 1

with Controller.from_port(port = 9151) as controller:
    controller.authenticate()
    for name in sys.argv[1:]:
        if name.endswith('.onion'):
            name = name[0:-6]
        print_hsdir(controller, name)
