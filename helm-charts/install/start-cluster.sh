#!/bin/bash

YELLOW="\e[33m"
NC="\e[0m"

function log {
	local msg=$1
	echo -e "${YELLOW}$msg${NC}"
}

function start_cluster {
    sudo minikube start --driver=none
    mkdir -p $HOME/.kube &&  sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config
    kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml > /dev/null
    log "Cluster is up!"
}

start_cluster
