#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM gitpod/workspace-full:latest

COPY .devcontainer/scripts /project/scripts

WORKDIR /project/scripts

RUN sh install-apptainer.sh
RUN sh install-gh.sh
