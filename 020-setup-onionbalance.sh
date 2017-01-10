#!/bin/sh -x

. `dirname $0`/000-profile.sh # defaults

pipurl=https://bootstrap.pypa.io/get-pip.py
pipfile=`basename $pipurl`

# OB wants a directory in /var/run, but does not create it
rundir=/var/run/onionbalance
test -d $rundir || sudo mkdir $rundir || exit 1
sudo chmod 01777 $rundir || exit 1

# i should really do a smart test for pip here, before just blatting it
if [ -f $pipfile ] ; then
    exit 0 # done
fi

wget $pipurl || exit 1
sudo python $pipfile || exit 1
sudo pip install onionbalance || exit 1
