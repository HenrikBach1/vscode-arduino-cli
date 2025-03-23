FROM debian:bullseye-slim AS base
#file="Dockerfile"

# Set reliable sources (remove unreliable mirror)
RUN echo "Setting up APT sources..." && \
    echo "deb http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list && \
    echo "deb http://security.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bullseye-updates main" >> /etc/apt/sources.list && \
    echo "deb http://ftp.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list

# Force APT to use IPv4 in case of DNS issues
RUN echo "Forcing APT to use IPv4..." && \
    echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

# Add logging for each step
RUN echo "Installing required packages..." && \
    for i in 1 2 3; do \
        echo "Attempt $i: Running apt-get update and install..." && \
        apt-get update && \
        apt-get install -y \
            curl \
            python3.9 \
            python3.9-venv \
            python3-pip \
            cmake \
            sudo \
            git \
            usbutils \
            kmod \
        && break || (echo "APT install failed. Retrying in 5 seconds..." && sleep 5); \
    done && apt-get clean

# Install Arduino CLI
RUN echo "Installing Arduino CLI..." && \
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

# Add environment detection logic
ARG CODESPACES=false
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=1000

# Ensure UID/GID defaults and set up the user based on the environment
RUN echo "Setting up user $USERNAME with UID=$USER_UID and GID=$USER_GID..." && \
    if ! getent group "${USER_GID:-1000}" >/dev/null; then groupadd --gid "${USER_GID:-1000}" devuser; fi && \
    if ! id -u "${USER_UID:-1000}" >/dev/null 2>&1; then useradd --uid "${USER_UID:-1000}" --gid "${USER_GID:-1000}" -m devuser; fi && \
    mkdir -p /home/devuser && \
    chown -R devuser:devuser /home/devuser

RUN echo "Detecting environment..." && \
    if [ "$CODESPACES" = "true" ]; then \
        echo "Environment detected: Codespaces" && \
        USERNAME=codespace && \
        if ! getent group 1000 >/dev/null; then groupadd --gid 1000 $USERNAME; fi && \
        if ! id -u 1000 >/dev/null 2>&1; then useradd --uid 1000 --gid 1000 -m $USERNAME; fi && \
        mkdir -p /home/$USERNAME && \
        chown -R $USERNAME:$USERNAME /home/$USERNAME && \
        mkdir -p /workspace && chown -R $USERNAME:$USERNAME /workspace; \
    else \
        echo "Environment detected: Local Machine" && \
        if ! getent group "${USER_GID:-1000}" >/dev/null; then groupadd --gid "${USER_GID:-1000}" $USERNAME; fi && \
        if ! id -u "${USER_UID:-1000}" >/dev/null 2>&1; then useradd --uid "${USER_UID:-1000}" --gid "${USER_GID:-1000}" -m $USERNAME; fi && \
        mkdir -p /home/$USERNAME && \
        chown -R $USERNAME:$USERNAME /home/$USERNAME; \
    fi

# Ensure the workspace folder exists in the container
RUN echo "Ensuring workspace folder exists..." && \
    mkdir -p /workspace && chown -R $USERNAME:$USERNAME /workspace

# Add user to necessary groups
RUN echo "Adding user $USERNAME to necessary groups..." && \
    if ! getent group dialout >/dev/null; then groupadd -g 20 dialout; fi && \
    if ! getent group plugdev >/dev/null; then groupadd -g 46 plugdev; fi && \
    usermod -aG dialout,plugdev,sudo $USERNAME

# Allow the user to use sudo without a password
RUN echo "Configuring sudo for $USERNAME..." && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Entry point for the container
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/bin/bash" ]
