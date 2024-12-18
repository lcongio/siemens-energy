#!/bin/sh

# Config
CONTAINER="grafana"
SCRIPT_DIR=$(dirname $(readlink -f $0))

# Check if the container already exists and is running
if [ "$(docker ps --all -q -f name=$CONTAINER)" ]; then
    echo "Stopping and removing the existing $CONTAINER container..."
    docker stop $CONTAINER && docker rm $CONTAINER
fi

docker run -d --name $CONTAINER \
        -e GF_SECURITY_ADMIN_USER=grafana \
        -e GF_SECURITY_ADMIN_PASSWORD=monitoring \
        -e GF_DATABASE_TYPE=postgres \
        -e GF_DATABASE_HOST=192.168.122.201:5432 \
        -e GF_DATABASE_NAME=grafana_storage \
        -e GF_DATABASE_USER=siemens \
        -e GF_DATABASE_PASSWORD=energy \
        -v $SCRIPT_DIR/provisioning/:/etc/grafana/provisioning/ \
        -p 3000:3000 \
        $CONTAINER:latest
