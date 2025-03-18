#!/bin/env bash
file="create-and-start-arduino-cli-docker-container.sh"

set -e  # Exit on any error
set -x  # Print commands for debugging

# Detect environment
if [ -n "$CODESPACES" ]; then
    echo "Environment detected: Codespaces"
    SSH_DIR="/workspaces/.ssh"  # Adjust path for Codespace
    PROJECTS_DIR="/workspaces/projects"  # Codespaces workspace
else
    echo "Environment detected: Local Machine"
    SSH_DIR="$HOME/.ssh"
    PROJECTS_DIR="/projects"
fi

# Docker container settings
export DOCKER_NAME=arduino-cli-docker
export IDF_IMAGE=arduino/arduino-cli:v0.33.0
SSH_KEY_NAME="docker_container_key"
SSH_KEY_PATH="$SSH_DIR/$SSH_KEY_NAME"

# Ensure SSH key exists
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N ""
fi

# Remove the existing Docker Container and the previously trusted SSH Key
docker rm -f $DOCKER_NAME || true
ssh-keygen -f "$SSH_DIR/known_hosts" -R '172.17.0.2'

# Start the container
docker run -d -it \
    -v $PROJECTS_DIR:/projects \
    -p 2222:22 \
    --device=/dev/ttyUSB0 \
    --device=/dev/ttyUSB1 \
    --name $DOCKER_NAME \
    $IDF_IMAGE
