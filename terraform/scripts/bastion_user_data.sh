#!/bin/bash

# Update system
sudo apt update -y
sudo apt upgrade -y

curl -LO https://dl.k8s.io/release/v1.35.0/bin/linux/amd64/kubectl

sudo install -o ubuntu -g ubuntu -m 0755 kubectl /usr/local/bin/kubectl

echo 'source <(kubectl completion bash)' >>~/.bashrc

source ~/.bashrc