#!/usr/bin/env bash

_DIR=$(cd "$(dirname "$0")"; pwd)
cd $_DIR


if ! hash sslocal 2>/dev/null ; then
pip install shadowsocks
fi

sslocal -c /etc/shawdowsocks/shawdowsocks.json start
