#!/bin/bash

YELLOW="\e[33m"
NC="\e[0m"

function log {
	local msg=$1
	echo -e "${YELLOW}$msg${NC}"
}

function install {
    log "Starting Helm Charts setup..."

    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

    sudo apt install apt-transport-https --yes

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

    sudo apt update

    sudo apt install helm

    log "End Helm Charts setup!"
}

install
