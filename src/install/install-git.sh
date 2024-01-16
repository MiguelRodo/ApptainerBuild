#!/usr/bin/env bash
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y ppa:git-core/ppa
apt update
apt install git
