#!/usr/bin/env bash
set -e
base_image_type="$1"
version_base="$2"
apt-get update
apt-get -y install apt-transport-https
apt-get update
apt-get -y install python3-pip libffi-dev
python3 -m pip --no-cache-dir install --upgrade pip setuptools
python3 -m pip --no-cache-dir install radian
install2.r --error --skipinstalled --ncpus -1 \
    jsonlite \
    devtools \
    usethis \
    yaml
if ! [ "$base_image_type" == "r" && "$version_base" == "36" ]; then
    install2.r --error --skipinstalled --ncpus -1 \
        renv
fi
rm -rf /tmp/downloaded_packages
