#!/bin/sh
# Get and setup the build compiler and the host compilers

X86_LINUX_HOST_URL="http://gdcproject.org/downloads/binaries/4.9.4/x86_64-linux-gnu/gdc-4.9.4+2.068.2_sysrooted.tar.xz"
X86_LINUX_HOST_FILE="gdc-4.9.4+2.068.2_sysrooted.tar.xz"
ARM_LINUX_HOST_URL="http://gdcproject.org/downloads/binaries/4.9.4/x86_64-linux-gnu/gdc-4.9.4+2.068.2-arm-linux-gnueabihf.tar.xz"
ARM_LINUX_HOST_FILE="gdc-4.9.4+2.068.2-arm-linux-gnueabihf.tar.xz"
X86_64_WINDOWS_HOST_URL="ftp://ftp.gdcproject.org/binaries/4.9.3/x86_64-linux-gnu/gdc-4.9.3-x86_64-w64-mingw32+2.066.1.tar.xz"
X86_64_WINDOWS_HOST_FILE="gdc-4.9.3-x86_64-w64-mingw32+2.066.1.tar.xz"
I686_WINDOWS_HOST_URL="ftp://ftp.gdcproject.org/binaries/4.9.3/x86_64-linux-gnu/gdc-4.9.3-i686-w64-mingw32+2.066.1.tar.xz"
I686_WINDOWS_HOST_FILE="gdc-4.9.3-i686-w64-mingw32+2.066.1.tar.xz"

set -e

pushd /home/build/
mkdir -p host-toolchains
pushd host-toolchains

wget -q ${X86_LINUX_HOST_URL}
tar xf ${X86_LINUX_HOST_FILE}
rm ${X86_LINUX_HOST_FILE}

wget -q ${ARM_LINUX_HOST_URL}
tar xf ${ARM_LINUX_HOST_FILE}
rm ${ARM_LINUX_HOST_FILE}

wget -q ${X86_64_WINDOWS_HOST_URL}
tar xf ${X86_64_WINDOWS_HOST_FILE}
rm ${X86_64_WINDOWS_HOST_FILE}

wget -q ${I686_WINDOWS_HOST_URL}
tar xf ${I686_WINDOWS_HOST_FILE}
rm ${I686_WINDOWS_HOST_FILE}

pushd x86_64-unknown-linux-gnu
    create_links.sh x86_64-unknown-linux-gnu x86_64_build-unknown-linux-gnu
    create_links.sh x86_64-unknown-linux-gnu x86_64_host-unknown-linux-gnu
    # Hack: libcpp does not properly configure AR and sometimes looks for 'ar' without prefix
    ln -s ../bin/ar xbin/ar
    # Hack: glibc does not configure readelf
    ln -s ../bin/readelf xbin/readelf
    # Hack for X86 to make sure we find libatomic
    pushd sysroot/usr/lib32
    ln -s ../../../lib32/libatomic.so libatomic.so
    popd
    pushd sysroot/usr/lib64
    ln -s ../../../lib64/libatomic.so libatomic.so
    popd
popd

pushd arm-unknown-linux-gnueabihf
create_links.sh arm-unknown-linux-gnueabihf arm_host-unknown-linux-gnueabihf
popd

pushd x86_64-w64-mingw32
create_links.sh x86_64-w64-mingw32 x86_64_host-w64-mingw32
popd

pushd i686-w64-mingw32
create_links.sh i686-w64-mingw32 i686_host-w64-mingw32
popd
