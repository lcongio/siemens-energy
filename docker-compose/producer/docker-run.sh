#!/bin/sh

# Config
CONTAINER="producer"
SCRIPT_DIR=$(dirname $(readlink -f $0))

# Check if the container already exists and is running
if [ "$(docker ps --all -q -f name=$CONTAINER)" ]; then
    echo "Stopping and removing the existing $CONTAINER container..."
    docker stop $CONTAINER && docker rm $CONTAINER
fi

docker run -d --name $CONTAINER \
        -e DB_HOST=192.168.122.201 \
        -e DB_PORT=5432 \
        -e DB_NAME=data_storage \
        -e DB_USER="siemens" \
        -e DB_PASSWORD="energy" \
        -v $SCRIPT_DIR/config:/config \
        $CONTAINER:latest
