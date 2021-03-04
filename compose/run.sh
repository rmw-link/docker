#!/usr/bin/env bash

if [ $EUID != 0 ]; then
sudo "$0" "$@"
exit $?
fi

_DIR=$(cd "$(dirname "$0")"; pwd)
cd $_DIR

if ! hash docker-compose 2>/dev/null ; then
pip install docker-compose
fi

# docker-compose up -d

# docker-compose 直到2020年07月还不支持 gpu，需要用下面的方法 hack
# https://github.com/docker/compose/issues/6691#issuecomment-571309691
# git clone --single-branch --branch  device-requests git@github.com:yoanisgil/compose.git --depth=1
# git clone --single-branch --branch  device-requests git@github.com:teklia/docker-py.git --depth=1
# 安装以上包，然后如下启动

COMPOSE_API_VERSION=auto docker-compose up -d 

