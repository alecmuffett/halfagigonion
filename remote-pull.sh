#!/bin/sh -x

. `dirname $0`/000-profile.sh

cd $RIG_REMOTE_DIR || exit 1

for host in $RIG_HOSTS
do
    # assume trailing slash in variables
    rsync-linktree.sh --delete --delete-excluded --exclude="cached*" --exclude=".git" $host:$RIG_OUTPUT_DIR tmp-$host/
done
