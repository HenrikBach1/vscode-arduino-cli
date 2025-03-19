FROM debian:bullseye-slim AS base
#file="Dockerfile"

# Set reliable sources
RUN echo "deb http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list && \
    echo "deb http://security.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bullseye-updates main" >> /etc/apt/sources.list && \
    echo "deb http://ftp.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirror.eu.kernel.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list

# Force APT to use IPv4 in case of DNS issues
RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

# Retry logic for apt-get update and apt-get install
RUN for i in 1 2 3; do \
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
    && break || sleep 5; \
done && apt-get clean

# Install Arduino CLI
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

# Add user and set permissions
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=1000

# Ensure UID/GID defaults and set up the user
RUN groupadd --gid "${USER_GID:-1000}" ${USERNAME} && \
    useradd --uid "${USER_UID:-1000}" --gid "${USER_GID:-1000}" -m ${USERNAME} && \
    mkdir -p /home/${USERNAME} && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

# Add devuser to dialout, plugdev, and sudo groups
RUN if ! getent group dialout >/dev/null; then groupadd -g 20 dialout; fi && \
    if ! getent group plugdev >/dev/null; then groupadd -g 46 plugdev; fi && \
    usermod -aG dialout,plugdev,sudo devuser

# Allow devuser to use sudo without a password
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

# Entry point for the container
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/bin/bash" ]
