COPY src/docker/ubuntu /project/src

WORKDIR /project/src

RUN sh install_apptainer.sh

