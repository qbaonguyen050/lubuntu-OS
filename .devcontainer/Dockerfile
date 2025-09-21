# Use the OFFICIAL Ubuntu 22.04 image as a base
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install our software, INCLUDING git-lfs
RUN apt-get update && apt-get install -y --no-install-recommends \
    lubuntu-desktop \
    novnc \
    websockify \
    x11vnc \
    xvfb \
    sudo \
    xterm \
    git \
    git-lfs \
    procps \
    firefox \
    && rm -rf /var/lib/apt/lists/*

# Set up a non-root user AND fix the git 'dubious ownership' error
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode:vscode" | chpasswd && \
    adduser vscode sudo && \
    su - vscode -c "git config --global --add safe.directory /workspaces/lubuntu-OS"

# Copy the debug script and make it executable
COPY debug-desktop.sh /.devcontainer/debug-desktop.sh
RUN chmod +x /.devcontainer/debug-desktop.sh

# Keep the container alive for the postCreateCommand
CMD ["sleep", "infinity"]