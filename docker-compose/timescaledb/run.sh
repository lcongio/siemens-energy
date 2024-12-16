#!/bin/sh

# Get the directory of the current script
SCRIPT_DIR=$(dirname $(readlink -f $0))

# Config
CONTAINER="timescaledb"
IMAGE=$CONTAINER:latest
VOLUME_NAME="pg_data"
PRODUCER_DB_NAME="create_producer_db.sql"
GRAFANA_DB_NAME="create_grafana_db.sql"
PRODUCER_DB_DIR="$SCRIPT_DIR/$PRODUCER_DB_NAME"
GRAFANA_DB_DIR="$SCRIPT_DIR/$GRAFANA_DB_NAME"
USERNAME=siemens
PASSWORD=energy
PORT=5432

# Check if the container already exists and is running
if [ "$(docker ps --all -q -f name=$CONTAINER)" ]; then
    echo "Stopping and removing the existing $CONTAINER container..."
    docker stop $CONTAINER && docker rm $CONTAINER
    [ "$1" = "clean" ] && docker volume rm pg_data
fi

# Create the container with the database and user
docker run -d --name $CONTAINER \
    -e POSTGRES_USER=$USERNAME \
    -e POSTGRES_PASSWORD=$PASSWORD \
    -v $VOLUME_NAME:/var/lib/postgresql/data \
    -v $PRODUCER_DB_DIR:/docker-entrypoint-initdb.d/$PRODUCER_DB_NAME \
    -v $GRAFANA_DB_DIR:/docker-entrypoint-initdb.d/$GRAFANA_DB_NAME \
    -p $PORT:$PORT \
    $IMAGE
