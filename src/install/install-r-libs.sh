#!/usr/bin/env bash
set -e
base_image="$1"
version_rbioc="$2"
if [[ "$base_image" == "r" && "$version_rbioc" == "36" ]]; then
  echo "deb http://archive.debian.org/debian/ stretch main" > /etc/apt/sources.list
  echo "deb-src http://archive.debian.org/debian/ stretch main" >> /etc/apt/sources.list
  echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until
fi

apt-get update
apt-get install -y \
  fonts-roboto \
  imagemagick \
  libcairo2-dev \
  libclang-dev \
  libfontconfig1-dev \
  libfreetype6-dev \
  libglpk40 \
  libicu-dev \
  libicu[0-9][0-9] \
  libsodium-dev \
  libssl-dev \
  libstdc++6 \
  libudunits2-dev \
  libxml2-dev \
  libxt-dev \
  locales \
  zlib1g

if [[ "$base_image" == "r" && "$version_rbioc" == "36" ]]; then
  apt-get install -y \
    libgit2-dev \
    libcurl4-gnutls-dev
else
  apt-get install -y \
    libgit2-dev \
    libcurl4-openssl-dev
fi