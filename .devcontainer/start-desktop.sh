#!/bin/bash

# This script runs in the background to not block the codespace
(
  set -e
  echo "--- [Desktop Startup] Starting services in the background ---"

  # 1. CLEANUP
  echo "--- [Desktop Startup] Cleaning up old X server lock file..."
  rm -f /tmp/.X0-lock

  # 2. START VIRTUAL SCREEN
  echo "--- [Desktop Startup] Starting virtual screen (Xvfb)..."
  Xvfb :0 -screen 0 1280x800x24 &
  sleep 3 # Give Xvfb time to start

  # 3. START DESKTOP AND TOOLS AS 'vscode' USER
  echo "--- [Desktop Startup] Starting Lubuntu Desktop (LXQt)..."
  su -l vscode -c "export DISPLAY=:0; startlxqt &"

  echo "--- [Desktop Startup] Starting VNC Server (x11vnc)..."
  su -l vscode -c "export DISPLAY=:0; x11vnc -display :0 -forever -passwd vscode -shared &"

  echo "--- [Desktop Startup] Starting Web Client (noVNC)..."
  su -l vscode -c "export DISPLAY=:0; websockify --web=/usr/share/novnc/ 6080 localhost:5900 &"

  echo "--- [Desktop Startup] All services launched. ---"
)