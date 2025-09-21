#!/bin/bash

# Start a virtual screen in the background
Xvfb :0 -screen 0 1280x800x24 &
sleep 2

# Set the DISPLAY environment variable
export DISPLAY=:0

# Start the Lubuntu desktop environment in the background
startlxqt &

# Start the VNC server in the background
x11vnc -display :0 -forever -passwd vscode -shared &

# Start the noVNC web client bridge in the background
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &

echo "Lubuntu desktop services have been started."

# Keep this script running forever
sleep infinity