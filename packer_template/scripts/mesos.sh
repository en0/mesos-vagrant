#!/bin/sh

# Setup
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

# Add the repository
echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" | \
      sudo tee /etc/apt/sources.list.d/mesosphere.list
sudo apt-get -y update

# Install mesos and marathon
sudo apt-get -y install mesos marathon

# Install docker
curl -sSL https://get.docker.com/ | sudo sh

# Install containerizors
echo 'docker,mesos' | sudo tee /etc/mesos-slave/containerizers
echo '5mins' | sudo tee /etc/mesos-slave/executor_registration_timeout
