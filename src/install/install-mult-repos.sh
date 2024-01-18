#!/usr/bin/env bash

set -e

pushd /tmp
git clone https://github.com/MiguelRodo/DevContainerFeatures.git
DevContainerFeatures/src/install/install-mult-repos.sh
rm -rf DevContainerFeatures.git
popd
