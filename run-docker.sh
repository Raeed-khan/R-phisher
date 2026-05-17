#!/bin/bash

# R-phisher Docker Wrapper Script

BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
AUTH_DIR="$BASE_DIR/auth"

# Creating Auth Directory if it doesn't exist
if [[ ! -d "$AUTH_DIR" ]]; then
    echo -e "\e[1;32m[+]\e[0m Creating Auth Directory..."
    mkdir -p "$AUTH_DIR"
fi

CONTAINER="r-phisher"
IMAGE="raeedkhan/r-phisher:latest"
IMG_MIRROR="ghcr.io/raeed-khan/r-phisher:latest"
MOUNT_LOCATION="${AUTH_DIR}"

# Checking if Docker daemon is running
if ! docker info > /dev/null 2>&1; then
    echo -e "\e[1;31m[-]\e[0m Error: Docker daemon is not running! Please start Docker first."
    exit 1
fi

# Checking if container already exists (Using grep for robust check)
if ! docker ps --all --format "{{.Names}}" | grep -q "^${CONTAINER}$"; then
    echo -e "\e[1;32m[+]\e[0m Pulling Docker Image..."
    # Try pulling from DockerHub, if fails try GHCR Mirror
    if ! docker pull "${IMAGE}"; then
        echo -e "\e[1;33m[!]\e[0m DockerHub pull failed, trying GHCR Mirror..."
        IMAGE="${IMG_MIRROR}"
        docker pull "${IMAGE}"
    fi

    echo -e "\e[1;32m[+]\e[0m Creating new container..."
    docker create \
        --interactive --tty \
        --volume "${MOUNT_LOCATION}:/r-phisher/auth/" \
        --network host \
        --name "${CONTAINER}" \
        "${IMAGE}"
fi

echo -e "\e[1;32m[+]\e[0m Starting ${CONTAINER}..."
docker start --interactive "${CONTAINER}"
