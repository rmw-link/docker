![Docker Image](https://github.com/ai-trade/docker/workflows/Docker%20Image/badge.svg)

# 系统初始化

```
apt-get update
apt-get install -y curl openssh-server tmux git
systemctl start ssh
systemctl enable ssh

```

# docker gpu 使用

1. `apt-get remove nvidia-* -y`

2. 安装最新驱动，32bit兼容可以不要，其他一路yes https://www.nvidia.cn/Download/index.aspx?lang=cn

3. `apt-get install -y nvidia-container-toolkit`

4. 注册 runtime，重启docker
```
sudo tee /etc/docker/daemon.json <<EOF
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
sudo pkill -SIGHUP dockerd
```

4. 运行 docker run --rm --gpus all nvidia/cuda:10.1-base nvidia-smi ，注意docker的cuda版本和nvidia-smi的cuda版本一致


