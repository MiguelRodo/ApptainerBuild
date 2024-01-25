#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "Error: no version provided."
    exit 1
fi

# parameter validation
version_orig="$1"

# Check if version_orig contains a dot
if [[ "$version_orig" != *.* ]]; then
    # If it doesn't, add a dot between the digits
    version_dot="${version_orig:0:1}.${version_orig:1}"
else
    # If it does, just use the original
    version_dot="$version_orig"
fi

if ! [[ "$version_dot" =~ ^(3.6|4.0|4.1|4.2|4.3)$ ]]; then
    echo "Version must be one of 3.6, 4.1, 4.2, 4.3."
    echo "For each of these, the latest patch version is used."
    echo "For example, 3.6 refers to the latest 3.6.x version, which is 3.6.3."
    exit 1
fi

version_dotless="${version_dot//./}"

# build the image
# --------------------
mkdir -p /tmp/sif
apptainer build -F "/tmp/sif/r${version_dotless}x.sif" "src/def/r${version_dotless}.def"
mkdir -p sif
cp "/tmp/sif/r${version_dotless}x.sif" "sif/r${version_dotless}x.sif"
