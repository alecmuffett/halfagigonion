#!/bin/sh -x

. `dirname $0`/000-profile.sh

packages="
emacs24-nox
git
haveged
ifstat
libevent-dev
libssl-dev
libyaml-dev
mailutils
nmap
nmh
oracle-java7-jdk
postfix
python-dev
rsync
socat
sqlite3
sysbench
tmux
zlib1g-dev
"

# put on one line for interpolation <sigh>
packages=`echo $packages`

# install it
while read cmd ; do
    sudo $cmd || exit 1
done <<EOF
aptitude -y update
aptitude -y upgrade
aptitude -y install $packages
timedatectl set-timezone Etc/UTC
EOF
