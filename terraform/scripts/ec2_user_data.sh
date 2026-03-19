#!/bin/bash

# Update system
sudo apt update -y
sudo apt upgrade -y

# Install SSM Agent
sudo apt install amazon-ssm-agent --classic -y

# Enable and start SSM Agent
sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

# Install MicroK8s
sudo snap install microk8s --classic
sudo usermod -aG microk8s ubuntu
newgrp microk8s

mkdir -p /home/ubuntu/.kube
chown ubuntu:ubuntu /home/ubuntu/.kube

# Wait for microk8s
microk8s status --wait-ready