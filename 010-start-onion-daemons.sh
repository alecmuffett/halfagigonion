#!/bin/sh -x

. `dirname $0`/000-profile.sh # defaults

999-kill-everything.sh || exit 1 # nuke any existing

# some folk in torproject feel that single onions are somehow
# dangerous and therefore should be complex to use, messy to
# administer and a single use should taint your keys irrevocably; i
# disagree, not least because i need to switch them on/off for
# comparison under onionbalance and don't want to mess with creating
# new keys, so let's hack around the bullshit and make it a boolean:
#SINGLE_ONION=false
SINGLE_ONION=true

# daemon config
num_daemons_per_node=5
num_ips_per_daemon=3

# launch the generator
( jchargen/run-jchargen.sh $num_daemons_per_node </dev/null >jchargen.log 2>&1 & ) &

# wait for java to catch up
sleep 8

# binaries
tor=/usr/local/bin/tor

# start the daemons
i=1
while [ $i -le $num_daemons_per_node ] ; do
    hs=hs$i
    dir=$RIG_OUTPUT_DIR/$hs.d
    chargen_port=`expr 8500 + $i` # hardcoded
    http_port=`expr 10500 + $i` # hardcoded

    test -d $dir || mkdir $dir || exit 1
    chmod 700 $dir

    # new config every time
    (
        # put EVERYTHING in one directory for convenience
        echo DataDirectory $dir
        echo HiddenServiceDir $dir
        echo ControlPort unix:$dir/control.sock
        echo Log info file $dir/log.txt
        echo SafeLogging 0 # noisy logging
        echo HeartbeatPeriod 60 minutes

        echo ""
        echo RunAsDaemon 1

        echo ""
        echo HiddenServiceNumIntroductionPoints $num_ips_per_daemon
        echo "#" HiddenServicePort 22 localhost:22
        echo HiddenServicePort 80 localhost:$http_port
        echo HiddenServicePort 19 localhost:$chargen_port

        # these are probably quite long-lived ports
        echo ""
        echo LongLivedPorts 19,22,80

        echo ""
        poison=$dir/onion_service_non_anonymous
        if $SINGLE_ONION ; then
            echo SocksPort 0 # single onions must ban SOCKS
            echo HiddenServiceSingleHopMode 1 # i want single-hop onions
            echo HiddenServiceNonAnonymousMode 1 # yes, really
            test -f $poison || touch $poison
        else
            echo SocksPort 0 # frankly we don't want SOCKS anyway
            test -f $poison && rm $poison
        fi

        # maybe disable entry guards
        echo ""
        echo "#" UseEntryGuards 0
        echo "#" UseEntryGuardsAsDirGuards 0
    ) > $dir/config

    $tor --hush -f $dir/config &

    i=`expr $i + 1`
done
