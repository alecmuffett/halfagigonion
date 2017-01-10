#!/bin/sh -x

. `dirname $0`/000-profile.sh

url=https://dist.torproject.org/tor-0.2.9.8.tar.gz
tarball=`basename $url`
dir=`basename $url .tar.gz`
lock=BUILT-$dir

test -f $lock && exit 0

if [ ! -f $tarball ] ; then
    wget $url || exit 1
fi

if [ ! -d $dir ] ; then
    tar xvfz $tarball || exit 1
fi

cd $dir || exit 1

if [ ! -f config.status ] ; then
    ./configure || exit 1
fi

make || exit 1
make test || exit 1
sudo make install || exit 1
rm -r $tarball $dir || exit 1
date > $lock

exit 0
