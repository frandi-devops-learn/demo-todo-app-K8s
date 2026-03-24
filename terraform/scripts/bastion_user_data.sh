#!/bin/bash
set -e  # stop script if any command fails

# Update system
sudo apt update -y
sudo apt upgrade -y

# Install dependencies
sudo apt install -y curl

# Install Helm
sudo snap install helm --classic

# Install kubectl (latest stable)
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl

install -o ubuntu -g ubuntu -m 0755 kubectl /usr/local/bin/kubectl

# Enable kubectl auto-completion for ubuntu user
echo 'source <(kubectl completion bash)' >> /home/ubuntu/.bashrc