#!/usr/bin/env bash
set -e 
apt-get update
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24
apt-get install -y software-properties-common
add-apt-repository -y ppa:git-core/ppa
apt-get update
apt-get upgrade -y
apt-get install -y git
