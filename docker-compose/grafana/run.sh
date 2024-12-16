#!/bin/sh

# Get the directory of the current script
SCRIPT_DIR=$(dirname $(readlink -f $0))

# Config
CONTAINER="grafana"
IMAGE=$CONTAINER:latest
DATABASE_TYPE=postgres
DATABASE_HOST=192.168.122.201:5432
DATABASE_NAME=grafana_storage
DATABASE_USER=siemens
DATABASE_PASSWORD=energy
DATASOURCES_DIR="$SCRIPT_DIR/provisioning/datasources"
DASHBOARDS_JSON_DIR="$SCRIPT_DIR/provisioning/dashboards_json"
GRAFANA_USERNAME=grafana
GRAFANA_PASSWORD=monitoring
PORT=3000

# Check if the container already exists and is running
if [ "$(docker ps --all -q -f name=$CONTAINER)" ]; then
    echo "Stopping and removing the existing $CONTAINER container..."
    docker stop $CONTAINER && docker rm $CONTAINER
fi

docker run -d --name $CONTAINER \
        -e GF_SECURITY_ADMIN_USER=$GRAFANA_USERNAME \
        -e GF_SECURITY_ADMIN_PASSWORD=$GRAFANA_PASSWORD \
        -e GF_DATABASE_TYPE=$DATABASE_TYPE \
        -e GF_DATABASE_HOST=$DATABASE_HOST \
        -e GF_DATABASE_NAME=$DATABASE_NAME \
        -e GF_DATABASE_USER=$DATABASE_USER \
        -e GF_DATABASE_PASSWORD=$DATABASE_PASSWORD \
        -v $DATASOURCES_DIR:/etc/grafana/provisioning/datasources \
        -v $DASHBOARDS_JSON_DIR:/etc/grafana/provisioning/dashboards_json \
        -p 3000:3000 \
        $IMAGE
