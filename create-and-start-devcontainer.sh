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

# Start VSCode with the DevContainer
code .devcontainer/.
