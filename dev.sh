#!/bin/bash

# This is just a script to setup the postgres dev environment
# Usage: './dev.sh' or './dev.sh up' or './dev.sh down'
#
# './dev.sh' and './dev.sh up' will try to create the postgres container
# './dev.sh down' will try to tear down the container
#
# DO NOT RUN WITH SUDO... Just since $(whoami) will say root rather
# than your username. You will still need sudo priv to run this successfully

# Constants
USERNAME=$(whoami)
PASSWORD="password"
PROJECT_NAME="spendthrift"
POSTGRES_IMG_NAME="postgres"
POSTGRES_IMG_VERSION="16.2"
CONTAINER_NAME=${USERNAME}s-dev-postgres

# Checking if the container already exists
if [[ $(sudo docker container ls -qf name="^${CONTAINER_NAME}$") ]]; then
    # Run this if 'down' was passed
    if [ "$(echo "$1" | tr '[:upper:]' '[:lower:]')" = "down" ]; then
        echo "Attempting to murder '${CONTAINER_NAME}' docker container"
        sudo docker container stop ${CONTAINER_NAME} > /dev/null
        # Checking if docker container stop was successful
        if [[ $(sudo docker container ls -qf name="^${CONTAINER_NAME}$") ]]; then
            echo "Unable to kill '${CONTAINER_NAME}'"
        else
            echo "Kill complete... 🔪"
        fi
        exit
    fi
    echo "Docker container is already running... Exec-ing now"
    sudo docker exec -it ${CONTAINER_NAME} /bin/bash
    exit
fi

# Checking if the postgresql/data directory exists...
# If it doesn't I'll make them. This holds all of the postgresql files
if ! [[ -d "./postgresql" ]]; then
    mkdir ./postgresql
fi

if ! [[ -d "./postgresql/data" ]]; then
    mkdir ./postgresql/data/
fi

# Building dev postgres container
echo "Creating docker container..."
sudo docker run --name ${CONTAINER_NAME} \
--user "$(id -u):$(id -g)" \
-v /etc/passwd:/etc/passwd:ro \
-v ./postgresql/data/:/var/lib/postgresql/data \
-v ./scripts/:/scripts \
-e POSTGRES_USER=${USERNAME} \
-e POSTGRES_PASSWORD=${PASSWORD} \
-e POSTGRES_DB=${PROJECT_NAME} \
--rm -d "${POSTGRES_IMG_NAME}:${POSTGRES_IMG_VERSION}"
sudo docker exec -it ${CONTAINER_NAME} /bin/bash
