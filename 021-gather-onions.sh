#!/bin/sh -x

. `dirname $0`/000-profile.sh # defaults

ONIONS=ob-onions.txt

for host in $RIG_HOSTS
do
    ssh $host "cat tmp/hs*.d/hostname"
done | sed -e s/.onion$// | sort > $ONIONS

(
    echo "REFRESH_INTERVAL: 300"
    echo "DESCRIPTOR_UPLOAD_PERIOD: 600"
    echo "DESCRIPTOR_VALIDITY_PERIOD: 1800"
    echo "LOG_LEVEL: info"
    echo "services:"
    echo "%%- key: master.key"
    echo "%%%%instances:"
    awk '{print "%%%%%%- address: '\''" $1 "'\''"}' < $ONIONS
) | sed -e 's/%/ /g' > ob-config.yaml
