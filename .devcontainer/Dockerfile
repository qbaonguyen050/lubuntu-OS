# Use the OFFICIAL Ubuntu 22.04 image as a base
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install only what we need
RUN apt-get update && apt-get install -y --no-install-recommends \
    lubuntu-desktop \
    novnc \
    websockify \
    x11vnc \
    xvfb \
    sudo \
    xterm \
    git \
    procps \
    firefox \
    && rm -rf /var/lib/apt/lists/*

# Set up a non-root user
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode:vscode" | chpasswd && \
    adduser vscode sudo

# Copy the startup script and make it executable
COPY start-desktop.sh /
RUN chmod +x /start-desktop.sh

# Set the default user
USER vscode
WORKDIR /home/vscode

# Keep the container alive
CMD ["sleep", "infinity"]