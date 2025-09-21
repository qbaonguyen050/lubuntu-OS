#!/bin/bash
set -e # Exit immediately if any command fails

echo "================================================="
echo "===   LUBUNTU DESKTOP ENVIRONMENT DEBUGGER    ==="
echo "================================================="

# --- CHECK 1: BASIC ENVIRONMENT ---
echo ""
echo "--- [CHECK 1/5] Verifying Users and Permissions ---"
echo "Running as user: $(whoami)"
echo "Sudo privileges test:"
sudo whoami
echo "USER 'vscode' exists: $(id -u vscode)"
echo "SUCCESS: Basic environment is sane."

# --- CHECK 2: DEPENDENCY VERIFICATION ---
echo ""
echo "--- [CHECK 2/5] Verifying Critical Binaries ---"
BINS=("Xvfb" "startlxqt" "x11vnc" "websockify" "firefox")
for bin in "${BINS[@]}"; do
  if command -v $bin &> /dev/null; then
    echo "  [OK] Found '$bin' at $(command -v $bin)"
  else
    echo "  [FAIL] Critical binary '$bin' is NOT INSTALLED."
    exit 1
  fi
done
echo "SUCCESS: All required programs are installed."

# --- CHECK 3: VIRTUAL SCREEN (Xvfb) TEST ---
echo ""
echo "--- [CHECK 3/5] Testing Virtual Screen (Xvfb) ---"
echo "Cleaning up old lock files..."
rm -f /tmp/.X0-lock
echo "Starting Xvfb on display :0..."
Xvfb :0 -screen 0 1280x800x24 &
XVFB_PID=$!
sleep 2

if ps -p $XVFB_PID > /dev/null; then
  echo "  [OK] Xvfb process is running with PID $XVFB_PID."
  if [ -f "/tmp/.X0-lock" ]; then
    echo "  [OK] X server lock file /tmp/.X0-lock was created."
  else
    echo "  [FAIL] Xvfb is running, but the lock file was NOT created."
  fi
else
  echo "  [FAIL] Xvfb process FAILED to start."
fi
echo "Stopping test Xvfb..."
kill $XVFB_PID
sleep 1
echo "SUCCESS: Virtual screen test complete."

# --- CHECK 4: DESKTOP CONNECTION TEST ---
echo ""
echo "--- [CHECK 4/5] Testing Desktop Connection ---"
echo "Starting a fresh Xvfb for this test..."
rm -f /tmp/.X0-lock
Xvfb :0 -screen 0 1280x800x24 &
XVFB_PID=$!
sleep 2
export DISPLAY=:0
echo "Attempting to launch a simple X-client (xterm) as 'vscode' user..."
# We expect this to fail if there's a problem with permissions or dbus
su -l vscode -c "export DISPLAY=:0; xterm -e 'echo TEST SUCCESSFUL && exit' &" || echo "  [INFO] 'su' command returned a non-zero exit code, which is expected during test."
sleep 3
if pgrep -f "xterm -e" > /dev/null; then
    echo "  [OK] Test X-client (xterm) successfully connected to the display."
    pkill -f xterm
else
    echo "  [FAIL] Could not launch a test X-client. The desktop environment (startlxqt) will likely fail."
    echo "  This often points to a D-Bus or permissions issue."
fi
echo "Stopping test Xvfb..."
kill $XVFB_PID
echo "SUCCESS: Desktop connection test complete."

# --- CHECK 5: SYSTEM LOGS ---
echo ""
echo "--- [CHECK 5/5] Dumping Relevant System Logs ---"
echo "Last 20 lines of /var/log/syslog:"
sudo tail -n 20 /var/log/syslog || echo "  No syslog found."
echo ""
echo "Last 20 lines of dmesg:"
sudo dmesg | tail -n 20 || echo "  dmesg not available."
echo ""

echo "================================================="
echo "===              DEBUGGING COMPLETE             ==="
echo "================================================="