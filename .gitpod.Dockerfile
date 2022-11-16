#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:22.04

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get upgrade -y \
  && apt-get install -y apt-utils \
  gdebi-core \
  openssh-client \
  gnupg2 \
  dirmngr \
  iproute2 \
  procps \
  lsof \
  htop \
  net-tools \
  psmisc \
  curl \
  wget \
  rsync \
  ca-certificates \
  unzip \
  zip \
  nano \
  vim-tiny \
  less \
  jq \
  lsb-release \
  apt-transport-https \
  dialog \
  libc6 \
  libgcc1 \
  libkrb5-3 \
  libgssapi-krb5-2 \
  libicu[0-9][0-9] \
  libicu-dev \
  libstdc++6 \
  zlib1g \
  locales \
  sudo \
  ncdu \
  man-db \
  strace \
  manpages \
  manpages-dev \
  librdf0-dev \
  init-system-helpers \
  && apt-get -y install \
  python3-pip \
  libgit2-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libxt-dev \
  libfontconfig1-dev \
  libcairo2-dev \
  && apt-get -y install \
  libgeos-dev \
  libgdal-dev \
  libproj-dev \
  libudunits2-dev \
  libsodium-dev \
  pandoc \
  openjdk-8-jdk \
  openjdk-8-jre \
  cargo \
  libfreetype6-dev \
  libclang-dev \
  ttf-mscorefonts-installer \
  fonts-roboto \
  && apt-get install -y git \
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*