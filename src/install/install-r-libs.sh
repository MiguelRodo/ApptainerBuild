#!/usr/bin/env bash
set -e
apt-get update
apt-get install -y \
  fonts-roboto \
  libcairo2-dev \
  libclang-dev \
  libfontconfig1-dev \
  libfreetype6-dev \
  libicu-dev \
  libicu[0-9][0-9] \
  libssl-dev \
  libstdc++6 \
  libxml2-dev \
  libxt-dev \
  locales \
  zlib1g

if ! [ "$1" == 36 ]; then
  apt-get install -y \
    imagemagick \
    libcurl4-openssl-dev \
    libgit2-dev \
    libglpk40 \
    libsodium-dev \
    libudunits2-dev
fi
