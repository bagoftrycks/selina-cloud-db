#!/usr/bin/env bash

# sudo ln -sf /opt/VBoxGuestAdditions-5.1.20/lib/VBoxGuestAdditions/mount.vboxsf /sbin/mount.vboxsf

BASE_SCRIPTS="/vagrant/scripts/"

cd "$BASE_SCRIPTS"

# Useful func
source "_lib.sh"

log "Update"
apt-get update

# Start serious things here!

# Install default
source bootstrap.sh

# Install docker
source docker.sh

# Install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

log "Setup complete!"
