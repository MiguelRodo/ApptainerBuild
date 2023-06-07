#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM gitpod/workspace-full:latest

COPY src/docker/ubuntu /project/src

WORKDIR /project/src

RUN sh install_apptainer.sh
RUN sh install_gh.sh
