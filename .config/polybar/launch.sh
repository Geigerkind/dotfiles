#!/bin/bash

# Terminate already running bar instances
killall -q polybar
sleep 1s
killall -s SIGKILL -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "" > /home/shino/log_polybar

# Launch Polybar, using default config location ~/.config/polybar/config
MONITORS=("eDP-1-1" "DP-0" "HDMI-0" "DP-1" "DP-2" "DVI-I-2-1" "DVI-I-3-2")
for MONITOR in "${MONITORS[@]}"; do
  xrandr | grep -q "${MONITOR} connected" && POLYBAR_MONITOR=${MONITOR} polybar std &> /home/shino/log_polybar &
done

echo "Polybar launched..."
