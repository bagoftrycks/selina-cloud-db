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

apt-get install curl -y

# Install docker-compose
if [[ ! -f /usr/local/bin/docker-compose ]]; then
  curl -L https://github.com/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
fi

# Config cassandra volumes shit
useradd cassandra
if [[ -d /data/var/db/cassandra ]]; then
  cp -r /data/var/db/cassandra /home/
  chown -R cassandra:cassandra /home/cassandra
fi

if [[ ! "$(crontab -l | grep "cassandra")" != "" ]]; then
  crontab -l > /tmp/cronshit
  echo "0 */3 * * * cp -r /home/cassandra /data/var/db/" >> /tmp/cronshit
  crontab /tmp/cronshit
  rm /tmp/cronshit
fi

# Config rethinkdb volumes shit
if [[ -d /data/var/db/rethinkdb ]]; then
  cp -r /data/var/db/rethinkdb /home/
fi

if [[ ! "$(crontab -l | grep "rethinkdb")" != "" ]]; then
  crontab -l > /tmp/cronshit
  echo "0 */3 * * * cp -r /home/rethinkdb /data/var/db/" >> /tmp/cronshit
  crontab /tmp/cronshit
  rm /tmp/cronshit
fi

log "Setup complete!"
