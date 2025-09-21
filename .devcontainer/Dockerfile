# Use the official Lubuntu 22.04 image as a base
FROM lubuntu/lubuntu:22.04

# Set environment variables to prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary software
# - supervisord: To run multiple services (VNC server and window manager)
# - novnc: The web-based VNC client
# - websockify: Bridges web sockets and TCP for noVNC
# - lxqt: The lightweight desktop environment for Lubuntu
# - sudo, xterm: Basic utilities
RUN apt-get update && apt-get install -y \
    supervisor \
    novnc \
    websockify \
    lxqt \
    sudo \
    xterm \
    && rm -rf /var/lib/apt/lists/*

# Set up a non-root user
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode:vscode" | chpasswd && \
    adduser vscode sudo

# Configure Supervisor to start the desktop environment and VNC server
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the port for noVNC
EXPOSE 6080

# Set the default user
USER vscode
WORKDIR /home/vscode

# Set the entrypoint to start Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]