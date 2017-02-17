#!/bin/sh
# Create a xbin directory and add symlinks for mangled executables
# E.g: create_links x86_64-unknown-linux-gnu x86_64_build-unknown-linux-gnu

set -e

REAL_TARGET=$1
LINK_TARGET=$2

mkdir -p xbin
for file in bin/*; do
    file=$(echo $file | cut -c 5-)
    case $file in 
        ${REAL_TARGET}* )
            name=$(echo "$file" | sed "s/${REAL_TARGET}/${LINK_TARGET}/g")
            if [ ! -f "xbin/$name" ]; then
                ln -s ../bin/$file "xbin/$name"
            fi
            ;;
        * )
            if [ ! -f "xbin/${LINK_TARGET}-$file" ]; then
                ln -s ../bin/$file "xbin/${LINK_TARGET}-$file"
            fi
            ;;
    esac
done
