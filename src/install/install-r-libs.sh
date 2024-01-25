#!/usr/bin/env bash
set -e
if [ "$1" == "36" ]; then
  echo "deb http://archive.debian.org/debian/ stretch main" > /etc/apt/sources.list
  echo "deb-src http://archive.debian.org/debian/ stretch main" >> /etc/apt/sources.list
  echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until
fi

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

if [ "$1" == "36" ]; then
  apt-get install -y \
    libgit2-dev \
    libcurl4-gnutls-dev
else
  apt-get install -y \
    libcurl4-openssl-dev \
    libgit2-dev \
    libglpk40 \
    libsodium-dev \
    libudunits2-dev
fi

apt-get install -y \
  imagemagick \
  libgit2-dev \
  libglpk40 \
  libsodium-dev \
  libudunits2-dev
