#!/bin/bash

YELLOW="\e[33m"
NC="\e[0m"

function log {
	local msg=$1

	echo -e "${YELLOW}$msg${NC}"
}

function install {
    log "Starting k8s installation..."

    sudo apt update

    # apt-transport-https may be a dummy package; if so, you can skip that package
    sudo apt install -y apt-transport-https ca-certificates curl gpg

    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    # This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt update
    sudo apt install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl

    log "End k8s installation!"
}

install
