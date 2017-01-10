#!/bin/sh -x
. `dirname $0`/000-profile.sh
killall tor
killall java
exit 0
