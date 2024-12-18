#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
DOCKER_IR=$SCRIPT_DIR/../../docker-compose/
COMPOSE_PROJECT_NAME="siemens-energy"
APP=("grafana" "timescaledb" "producer")
TAG=1.0.0

YELLOW="\e[33m"
NC="\e[0m"

function log {
	local msg=$1
	echo -e "${YELLOW}$msg${NC}"
}

function build_images {
    log "Building images..."
    docker compose -f "$DOCKER_IR/docker-compose.yaml" build
}


function load_images {
    log "Loading images..."
    cd /tmp || exit
    for app in "${APP[@]}"; do
        image="$COMPOSE_PROJECT_NAME-$app"
        docker tag "$image:latest" "$image:$TAG"
        docker save -o "$image.tar.gz" "$image:$TAG"
        minikube image load "$image.tar.gz"
        rm "$image.tar.gz"
    done
    minikube image ls | grep $COMPOSE_PROJECT_NAME
    log "Images loaded!"
}

build_images
load_images
