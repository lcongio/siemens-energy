#!/bin/sh

# Get the directory of the current script
SCRIPT_DIR=$(dirname $(readlink -f $0))

echo "$SCRIPT_DIR"

# Config
CONTAINER="producer"
CONFIG_DIR="$SCRIPT_DIR/config"
DB_HOST="192.168.122.201"
DB_PORT="5432"
DB_NAME="data_storage"
DB_USER="siemens"
DB_PASSWORD="energy"

# Check if the container already exists and is running
if [ "$(docker ps --all -q -f name=$CONTAINER)" ]; then
    echo "Stopping and removing the existing $CONTAINER container..."
    docker stop $CONTAINER && docker rm $CONTAINER
fi

docker run -d --name $CONTAINER \
        -e DB_HOST=$DB_HOST \
        -e DB_PORT=$DB_PORT \
        -e DB_NAME=$DB_NAME \
        -e DB_USER=$DB_USER \
        -e DB_PASSWORD=$DB_PASSWORD \
        -v $CONFIG_DIR:/config \
        $CONTAINER:latest
