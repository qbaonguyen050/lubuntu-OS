#!/bin/bash

# Clean up any leftover X server lock files
rm -f /tmp/.X0-lock

# Start a virtual screen in the background as root
Xvfb :0 -screen 0 1280x800x24 &
sleep 2

# Set the DISPLAY environment variable for all subsequent commands
export DISPLAY=:0

# Use `su` to run the following commands as the 'vscode' user
su - vscode -c "startlxqt &"
su - vscode -c "x11vnc -display :0 -forever -passwd vscode -shared &"
su - vscode -c "websockify --web=/usr/share/novnc/ 6080 localhost:5900 &"

echo "Lubuntu desktop services have been started."