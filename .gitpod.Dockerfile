#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM gitpod/workspace-full:latest

WORKDIR /tmp
COPY src .



