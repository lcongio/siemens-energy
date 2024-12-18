#!/bin/bash

YELLOW="\e[33m"
NC="\e[0m"

function log {
	local msg=$1
	echo -e "${YELLOW}$msg${NC}"
}

function k8s_install {
    log "Starting K8s setup..."

    log "Installing kubectl"

    cd /tmp || exit

    curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    log "Installing minikube"

    curl -sLO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

    log "Initializing the cluster"

    sudo minikube start --driver=none

    log "End K8s setup!"
}

function k8s_service {
    sudo bash -c "cat <<EOF > /etc/systemd/system/minikube.service
[Unit]
Description=Minikube Kubernetes Cluster
Wants=network-online.target docker.service

[Service]
Type=simple
User=$(whoami)
Environment=PATH=/usr/local/bin:/usr/bin:/bin
ExecStart=sudo /usr/local/bin/minikube start --driver=none

[Install]
WantedBy=multi-user.target
EOF"

    sudo systemctl daemon-reload
    sudo systemctl enable minikube.service
    sudo systemctl start minikube.service
}

k8s_install
k8s_service
