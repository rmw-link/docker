#!/usr/bin/env bash

# bash <(curl -sL http://t.cn/A6UyO55v)

sudo apt-get update
curl -fsSL https://get.docker.com | sudo bash -s docker --mirror Aliyun
sudo systemctl start docker
sudo systemctl enable docker
