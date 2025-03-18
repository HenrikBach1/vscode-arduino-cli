#!/bin/bash
file=setup_espidf.sh

# # Set the ESP-IDF path
# export IDF_PATH="/opt/esp/idf"

# # Function to install ESP-IDF tools
# install_tools() {
#     echo "Installing ESP-IDF tools..."
#     /usr/bin/python3 $IDF_PATH/tools/idf_tools.py install
# }

# # Function to install the Python environment
# install_python_env() {
#     echo "Installing ESP-IDF Python environment..."
#     /usr/bin/python3 $IDF_PATH/tools/idf_tools.py install-python-env
# }

# Function to install cmake without sudo
install_cmake() {
    echo "Installing cmake..."
    apt-get update
    apt-get install -y cmake
}

# Function to install pip
install_pip() {
    echo "Installing pip..."
    apt-get install -y python3-pip
}

# Function to export environment variables
export_env_vars() {
    echo "Exporting environment variables..."
    . $IDF_PATH/export.sh
}

# Function to add cmake to PATH
add_cmake_to_path() {
    echo "Finding cmake..."
    CMAKE_PATH=$(find / -name cmake | grep "/bin/cmake" | head -n 1)
    if [ -n "$CMAKE_PATH" ]; then
        CMAKE_DIR=$(dirname "$CMAKE_PATH")
        if [[ ":$PATH:" != *":$CMAKE_DIR:"* ]]; then
            export PATH=$PATH:$CMAKE_DIR
            echo "export PATH=\$PATH:$CMAKE_DIR" >> ~/.bashrc
            source ~/.bashrc
            echo "cmake has been added to the PATH."
        else
            echo "cmake is already in the PATH."
        fi
    else
        echo "cmake could not be found. Please install it manually."
    fi
}

# # Main script execution
# echo "Starting ESP-IDF setup..."

# install_tools
# install_python_env
# install_cmake
# install_pip
# add_cmake_to_path

# export_env_vars

# # Verify the installation
# echo "Verifying ESP-IDF installation..."
# idf.py --version

# echo "ESP-IDF setup complete!"
