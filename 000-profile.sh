#!/bin/sh

set -x

# make sure to use trailing slashes
RIG_MASTER_DIR=$HOME/master.d/
RIG_WORKER_DIR=$HOME/worker.d/
RIG_REMOTE_DIR=$HOME/remote.d/
RIG_OUTPUT_DIR=$HOME/tmp/

# backplane-rig0
RIG_HOSTS="
backplane-rig0
backplane-rig1
backplane-rig2
backplane-rig3
backplane-rig4
backplane-rig5
backplane-rig6
"

export RIG_MASTER_DIR
export RIG_WORKER_DIR
export RIG_REMOTE_DIR
export RIG_OUTPUT_DIR
export RIG_HOSTS

# all operations are done from the OUTPUT dir
if [ ! -d $RIG_OUTPUT_DIR ] ; then
    mkdir $RIG_OUTPUT_DIR || exit 1
    chmod 01777 $RIG_OUTPUT_DIR || exit 1
fi
cd $RIG_OUTPUT_DIR || exit 1

# run path through the WORKER dir; keep it up to date!
PATH=$RIG_WORKER_DIR:$PATH
export PATH
