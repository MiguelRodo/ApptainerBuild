# source: https://apptainer.org/docs/admin/main/installation.html
# date created: 2023 June 06
# date last modified: 2023 June 07
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:apptainer/ppa
sudo apt-get update
sudo apt-get install -y apptainer
# as singularity mounts localtime
# source: https://carpentries-incubator.github.io/singularity-introduction/07-singularity-images-building/index.html#using-singularity-run-from-within-the-docker-container
sudo apt-get install -y tzdata
sudo cp /usr/share/zoneinfo/Europe/London /etc/localtime
