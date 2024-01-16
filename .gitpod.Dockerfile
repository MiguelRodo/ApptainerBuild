#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM gitpod/workspace-full:latest

COPY .devcontainer/scripts /project/scripts

WORKDIR /project/scripts

RUN install-apptainer.sh
RUN install-gh.sh
