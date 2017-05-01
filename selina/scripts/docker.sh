#!/usr/bin/env bash

source "_lib.sh"

log "--- Start: Bootstrap Docker host ---"

KERNEL="uname -r"
KERNEL_VERSION_MAJOR=$($KERNEL | sed -n "s/^\([0-9]\).*/\1/p")
KERNEL_VERSION_MINOR=$($KERNEL | sed -n "s/^[0-9]\.\([0-9][0-9]\).*/\1/p")

if [[ $KERNEL_VERSION_MAJOR < 3 ]]; then
  log "--- End: Error: kernel version major not supported ---"
  log "--- End: Bootstrap Docker host ---"
  exit 1
fi

if [[ $KERNEL_VERSION_MINOR < 10 ]]; then
  log "--- End: Error: kernel version minor not supported ---"
  log "--- End: Bootstrap Docker host ---"
  exit 1
fi

if [[ "$(dpkg --get-selections | grep "docker-ce")" == "" ]]; then
  apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  add-apt-repository \
           "deb [arch=amd64] https://download.docker.com/linux/debian \
           $(lsb_release -cs) \
           stable"

  apt-get update
  apt-get -y install docker-ce

  GROUP_DOCKER="docker"
  if [[ "$(getent group "$GROUP_DOCKER" | grep "$GROUP_DOCKER")" != "" ]]; then
    log "group $GROUP_DOCKER does exist"
  else
    addgroup "$GROUP_DOCKER"
  fi
  usermod -aG docker vagrant
  systemctl enable docker
  docker run hello-world
fi

log "--- End: Bootstrap Docker host ---"
