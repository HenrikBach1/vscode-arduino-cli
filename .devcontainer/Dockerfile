FROM debian:bullseye-slim AS base
#file="Dockerfile"

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    python3.9 \
    python3.9-venv \
    python3-pip \
    cmake \
    && apt-get clean

# Install Arduino CLI
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

# Add user and set permissions
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=1000

# Ensure UID/GID defaults if not passed during build
RUN groupadd --gid ${USER_GID:-1000} ${USERNAME} \
    && useradd --uid ${USER_UID:-1000} --gid ${USER_GID:-1000} -m ${USERNAME} \
    && mkdir -p /home/${USERNAME} \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

# Entry point for the container
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/bin/bash" ]
