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
    # Add the binary to the path
    echo "export PATH=\$PATH:\$HOME/bin" >> ~/.bashrc
    export PATH=$PATH:$HOME/bin
fi

# Generate Arduino CLI configuration
mkdir -p "$ARDUINO_CLI_CONFIG_PATH"
arduino-cli config init --dest "$ARDUINO_CLI_CONFIG_PATH"

# Add additional boards URLs
arduino-cli config add board_manager.additional_urls https://downloads.arduino.cc/packages/package_index.json
arduino-cli config add board_manager.additional_urls https://arduino.esp8266.com/stable/package_esp8266com_index.json
arduino-cli config add board_manager.additional_urls https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json

# Install required board cores (example: Arduino AVR boards)
echo "Updating board index..."
arduino-cli core update-index
echo "Installing Arduino AVR core..."
arduino-cli core install arduino:avr
echo "Installing ESP8266 core..."
arduino-cli core install esp8266:esp8266
echo "Installing ESP32 core..."
arduino-cli core install esp32:esp32

# List installed boards for verification
echo "Installed boards:"
arduino-cli board listall

# Install common libraries
echo "Installing common libraries..."
arduino-cli lib install "ArduinoJson"
arduino-cli lib install "PubSubClient"
arduino-cli lib install "Adafruit Unified Sensor"
arduino-cli lib install "DHT sensor library"

echo "Arduino CLI setup complete!"
