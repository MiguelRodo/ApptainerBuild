#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:22.04

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get upgrade -y \
  && apt-get install -y apt-utils 