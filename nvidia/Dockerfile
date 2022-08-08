FROM nvidia/cuda:11.6.0-base-ubuntu20.04 as build

RUN \
apt-get update &&\
apt-get install -y software-properties-common &&\
add-apt-repository -y ppa:neovim-ppa/stable &&\
apt-get update
