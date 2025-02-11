#!/bin/sh

# Install required softwares on a fresh Ubuntu 24.04 install for self-hosted github runner
sudo apt-get install curl
sudo apt-get install git-all
sudo apt-get install git-lfs
sudo apt-get install make
sudo apt-get install gcc
sudo apt-get install 7zip
sudo apt-get install brotli

# Enable ssh
sudo apt-get install net-tools
sudo apt-get install openssh-server

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Fix permissions
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Fix permissions for ruby
sudo mkdir -p /opt/hostedtoolcache
sudo chown -R $USER:$USER /opt/hostedtoolcache