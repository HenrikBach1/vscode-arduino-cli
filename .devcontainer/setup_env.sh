#!/bin/bash
file="setup_env.sh"

# Detect environment
if [ -n "$CODESPACES" ]; then
    echo "Environment detected: Codespaces"
    ARDUINO_CLI_CONFIG_PATH="/workspaces/.arduino-cli"
else
    echo "Environment detected: Local Machine"
    ARDUINO_CLI_CONFIG_PATH="/home/devuser/.arduino-cli"
fi

# Set up Arduino CLI
if ! command -v arduino-cli &> /dev/null; then
    echo "Arduino CLI not found. Installing..."
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
fi

# Generate Arduino CLI configuration
mkdir -p "$ARDUINO_CLI_CONFIG_PATH"
arduino-cli config init --dest "$ARDUINO_CLI_CONFIG_PATH"

# Install required board cores (example: Arduino AVR boards)
arduino-cli core update-index
arduino-cli core install arduino:avr
