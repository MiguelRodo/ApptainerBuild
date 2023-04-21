FROM mcr.microsoft.com/devcontainers/base:jammy
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get upgrade -y
RUN sudo apt update \
  && sudo apt install -y software-properties-common \
  && sudo add-apt-repository -y ppa:apptainer/ppa \
  && sudo apt update \
  && sudo apt install -y apptainer
