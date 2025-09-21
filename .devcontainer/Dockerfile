# Use the OFFICIAL Ubuntu 22.04 image as a base
FROM ubuntu:22.04

# Set environment variables to prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install the full Lubuntu desktop, VNC server, and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    lubuntu-desktop \
    supervisor \
    novnc \
    websockify \
    x11vnc \
    xvfb \
    sudo \
    xterm \
    git \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Set up a non-root user
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode:vscode" | chpasswd && \
    adduser vscode sudo

# Configure Supervisor to start all services
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the port for noVNC (web access) and VNC (desktop client access)
EXPOSE 6080 5900

# Set the default user
USER vscode
WORKDIR /home/vscode

# Keep the container alive
CMD ["sleep", "infinity"]