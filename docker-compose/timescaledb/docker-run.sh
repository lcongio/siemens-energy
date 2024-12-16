#!/bin/sh

# Config
CONTAINER="timescaledb"
SCRIPT_DIR=$(dirname $(readlink -f $0))

# Check if the container already exists and is running
if [ "$(docker ps --all -q -f name=$CONTAINER)" ]; then
    echo "Stopping and removing the existing $CONTAINER container..."
    docker stop $CONTAINER && docker rm $CONTAINER
    [ "$1" = "clean" ] && docker volume rm pg_data
fi

# Create the container with the database and user
docker run -d --name $CONTAINER \
    -e POSTGRES_USER=siemens \
    -e POSTGRES_PASSWORD=energy \
    -v pg_data:/var/lib/postgresql/data \
    -v $SCRIPT_DIR/create_producer_db.sql:/docker-entrypoint-initdb.d/create_producer_db.sql \
    -v $SCRIPT_DIR/create_grafana_db.sql:/docker-entrypoint-initdb.d/create_grafana_db.sql \
    -p 5432:5432 \
    $CONTAINER:latest
