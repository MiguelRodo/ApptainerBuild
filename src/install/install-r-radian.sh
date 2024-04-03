#!/usr/bin/env bash
set -e
base_image="$1"
version_rbioc="$2"
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
if ! [ "$base_image" == "r" && "$version_rbioc" == "36" ]; then
    install2.r --error --skipinstalled --ncpus -1 \
        renv
fi
rm -rf /tmp/downloaded_packages
