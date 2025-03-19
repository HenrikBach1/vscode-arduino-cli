#!/bin/bash
file="create-and-start-devcontainer.sh"

# Environment detection
if [ -n "$CODESPACES" ]; then
    echo "Environment detected: Codespaces"
else
    echo "Environment detected: Local Machine"
fi

# Ensure USER_UID and USER_GID are set
export USER_UID=$(id -u)
export USER_GID=$(id -g)

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Build the DevContainer
echo "Building the Arduino CLI DevContainer image..."
docker build \
    --build-arg USER_UID="$USER_UID" \
    --build-arg USER_GID="$USER_GID" \
    -t arduino-cli-image \
    -f .devcontainer/Dockerfile .

if [ $? -ne 0 ]; then
    echo "Failed to build the Arduino CLI DevContainer. Please check the Dockerfile and try again."
    exit 1
fi

# Start VSCode with the DevContainer
echo "Starting VSCode with the Arduino CLI DevContainer..."
code .devcontainer/.
