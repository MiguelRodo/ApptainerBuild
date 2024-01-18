#!/usr/bin/env bash

pushd /tmp
git clone https://github.com/MiguelRodo/DevContainerFeatures.git
cd DevContainerFeatures
src/install/install-mult-repos.sh
cd ..
rm -rf DevContainerFeatures.git
popd
