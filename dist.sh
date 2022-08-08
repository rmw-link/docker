#!/usr/bin/env bash
set -ex
_DIR=$(cd "$(dirname "$0")"; pwd)
cd $_DIR

#export DOCKER_CLI_EXPERIMENTAL=enabled
#docker push rmwl/dev
# cp Dockerfile

for os in $(ls docker/)
do
dockerfile=docker/$os/Dockerfile
cat Dockerfile >> $dockerfile
docker build -t rmwl/$os -f $dockerfile .
docker push rmwl/$os
git checkout $dockerfile
done


