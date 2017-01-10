#!/bin/sh

date

find /sys/class/net/*/statistics/ -type f |
    sort |
    while read f ; do
        echo "#" $f: `cat $f`
    done

exit 0
