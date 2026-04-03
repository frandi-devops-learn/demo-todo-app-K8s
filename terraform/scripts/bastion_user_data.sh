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

mkdir -p /home/ubuntu/.kube
chown ubuntu:ubuntu /home/ubuntu/.kube

# Install Argo CD CLI
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64

chmod +x argocd

sudo mv argocd /usr/local/bin/

# Install kubeseal CLI
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.24.0/kubeseal-0.24.0-linux-amd64.tar.gz

tar -xzf kubeseal-0.24.0-linux-amd64.tar.gz kubeseal

chmod +x kubeseal

sudo mv kubeseal /usr/local/bin/

rm -rf kubeseal-0.24.0-linux-amd64.tar.gz