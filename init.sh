#!/bin/bash

# Abort on every error
set -e

# Functions
createFileLink() {
  if [ ! -f $DATA_VOLUME/$1 ]; then
    touch $DATA_VOLUME/$1
    echo "$2" > $DATA_VOLUME/$1
  fi
  rm -f $1
  ln -s $DATA_VOLUME/$1 $1
}

createDirLink() {
  mkdir -p $DATA_VOLUME/$1
  rm -f $1
  ln -s $DATA_VOLUME/$1 $1
}

# Set symlinks to data volume
sleep 10
createDirLink config
createDirLink world
createFileLink server.properties "$(< server.properties.template)"
createFileLink ops.json '[]'
createFileLink whitelist.json '[]'
createFileLink usercache.json '[]'
createFileLink banned-ips.json '[]'
createFileLink banned-players.json '[]'
sleep 10

# Generate random rcon password
PASSWORD=$(openssl rand -hex 20)
sed --follow-symlinks -i -e 's/rcon.password=.*/rcon.password='$PASSWORD'/g' server.properties
sed --follow-symlinks -i -e 's/PASSWORD=.*/PASSWORD='$PASSWORD'/g' rcon
PASSWORD=dummy
