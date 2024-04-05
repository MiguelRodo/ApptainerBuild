#!/usr/bin/env bash
set -e 
apt-get clean
rm -rf /var/lib/apt/lists/*
apt-get update
apt-get install -y gnupg gnupg2 gnupg1
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24
apt-get install -y software-properties-common
add-apt-repository -y ppa:git-core/ppa
apt-get update
apt-get install -y git
