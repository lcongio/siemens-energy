#!/bin/bash

YELLOW="\e[33m"
NC="\e[0m"

function log {
	local msg=$1

	echo -e "${YELLOW}$msg${NC}"
}

function install {
	log "Add Docker's official GPG key"
	sudo apt update
	sudo apt install -y ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	log "Add the repository to Apt sources"
	echo \
		  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
		    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
		      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	log "Update packages"
	sudo apt update

	log "Install packages"
	sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	log "Test Docker"
	sudo docker run hello-world

	log "Create Docker Group"
	sudo groupadd docker

	log "Add user to Docker Group"
	sudo usermod -aG docker $USER

	log "Update Groups"
	newgrp docker
}

install
