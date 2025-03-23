#!/bin/bash
file="create-and-start-devcontainer.sh"

# Environment detection
if [ -n "$CODESPACES" ]; then
    echo "Environment detected: Codespaces"
    PROJECTS_DIR="/workspace"
else
    echo "Environment detected: Local Machine"
    PROJECTS_DIR="/projects"
    if [ ! -d "$PROJECTS_DIR" ]; then
        echo "Creating projects folder at $PROJECTS_DIR on the host machine..."
        mkdir -p "$PROJECTS_DIR"
    fi
fi

# Ensure the directory is writable
if [ ! -w "$PROJECTS_DIR" ]; then
    echo "Error: $PROJECTS_DIR is not writable. Please check permissions."
    exit 1
fi

# Ensure USER_UID and USER_GID are set
export USER_UID=$(id -u)
export USER_GID=$(id -g)
echo "Using USER_UID=$USER_UID and USER_GID=$USER_GID"

# Log resolved paths and environment variables
echo "Resolved PROJECTS_DIR: $PROJECTS_DIR"
echo "Resolved workspaceMount: source=${HOME}/projects,target=${CODESPACES:+/workspace}${CODESPACES:/projects},type=bind"
echo "Resolved workspaceFolder: ${CODESPACES:+/workspace}${CODESPACES:/projects}"
echo "CODESPACES environment variable: $CODESPACES"

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
if [ -n "$CODESPACES" ]; then
    echo "Starting the Arduino CLI DevContainer in Codespaces..."
    docker run --rm -it \
        --mount type=bind,source="$PROJECTS_DIR",target=/workspace \
        arduino-cli-image
else
    echo "Starting VSCode with the Arduino CLI DevContainer on the local machine..."
    code .devcontainer/.
fi
