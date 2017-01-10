#!/bin/sh

. `dirname $0`/000-profile.sh

cd $RIG_MASTER_DIR || exit 1

reaper3

for host in $RIG_HOSTS
do
    rsync-linktree.sh --exclude=".git/" --delete-excluded ./ $host:worker.d/
done
