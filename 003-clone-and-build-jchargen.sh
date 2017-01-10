#!/bin/sh -x
. `dirname $0`/000-profile.sh
test -f jchargen || git clone https://github.com/alecmuffett/jchargen.git
cd jchargen || exit 1
git pull # or whatever
make || exit 1
exit 0
