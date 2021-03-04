#!/usr/bin/env bash

_DIR=$(cd "$(dirname "$0")"; pwd)
cd $_DIR

# echo https://shimo.im/docs/9Hy3XQChhqTjdkXw

# apt-get remove nvidia-* -y
# wget -c https://cn.download.nvidia.com/XFree86/Linux-x86_64/450.57/NVIDIA-Linux-x86_64-450.57.run

#distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
distribution=debian10
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo tee /etc/docker/daemon.json <<EOF
{
"registry-mirrors":["https://reg-mirror.qiniu.com/"],
"runtimes": {
"nvidia": {
    "path": "nvidia-container-runtime",
    "runtimeArgs": []
}
}}
EOF


sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
