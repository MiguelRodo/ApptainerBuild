#!/usr/bin/env bash
set -e
apt-get update
apt-get -y install python3-pip
python3 -m pip --no-cache-dir install radian
install2.r --error --skipinstalled --ncpus -1 \
    jsonlite \
    devtools \
    usethis \
    yaml \
if ! [ "$1" == 36 ]; then
    install2.r --error --skipinstalled --ncpus -1 \
        languageserver \
        httpgd \
        renv \
        yaml \
fi
rm -rf /tmp/downloaded_packages
