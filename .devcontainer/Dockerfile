FROM mcr.microsoft.com/devcontainers/universal:latest

COPY src/docker/ubuntu /project/src

WORKDIR /project/src

RUN sh install_apptainer.sh
RUN sh install_gh.sh
RUN sh install_vscode.sh
