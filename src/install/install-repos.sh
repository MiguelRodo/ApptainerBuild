#!/usr/bin/env bash

set -e

if [ -d "/tmp/DevContainerFeatures" ]; then
    git -C /tmp/DevContainerFeatures pull
else
    git clone https://github.com/MiguelRodo/DevContainerFeatures.git /tmp/DevContainerFeatures
fi
/tmp/DevContainerFeatures/src/repos/install.sh
rm -rf /tmp/DevContainerFeatures
