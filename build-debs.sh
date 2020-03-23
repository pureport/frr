#!/bin/bash -e

EXTRA_VERSION="-pureport1"
DEBIAN_FRONTEND=noninteractive

# Make read-write copy of source code
mkdir -p /build
cp -a /src /build/source
cd /build/source

# Install build dependencies
apt-get update
apt-get install -y \
   git autoconf automake libtool make libreadline-dev texinfo \
   pkg-config libpam0g-dev libjson-c-dev bison flex python3-pytest \
   libc-ares-dev python3-dev libsystemd-dev python-ipaddress python3-sphinx \
   install-info build-essential libsystemd-dev libsnmp-dev perl libcap-dev \
   chrpath gawk fakeroot debhelper devscripts libpcre3-dev wget
wget https://ci1.netdef.org/artifact/LIBYANG-YANGRELEASE/shared/build-10/Debian-AMD64-Packages/libyang-dev_0.16.105-1_amd64.deb
wget https://ci1.netdef.org/artifact/LIBYANG-YANGRELEASE/shared/build-10/Debian-AMD64-Packages/libyang0.16_0.16.105-1_amd64.deb
dpkg -i libyang*.deb

# Version and build packages
./tools/tarsource.sh -V -e "${EXTRA_VERSION}"
dpkg-buildpackage -Ppkg.frr.nortrlib

# Copy packages to output dir with user's permissions
chown -R $USER:$GROUP /build
cp -a /build/*.deb /build/source/libyang*.deb /output/
