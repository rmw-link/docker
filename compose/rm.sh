#!/usr/bin/env bash

if [ $EUID != 0 ]; then
sudo "$0" "$@"
exit $?
fi

_DIR=$(cd "$(dirname "$0")"; pwd)
cd $_DIR

docker-compose stop
docker-compose rm -f
