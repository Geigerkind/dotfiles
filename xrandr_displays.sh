#!/bin/bash

OUTPUTS="--output eDP-1-1 --mode 1920x1080"
LAST_OUTPUT="eDP-1-1"

MONITORS=("DP-0" "HDMI-0" "DP-1" "DP-2")
XRANDR_OUTPUT=$(xrandr)
for MONITOR in "${MONITORS[@]}"; do
	if echo "${XRANDR_OUTPUT}" | grep -q "${MONITOR} connected" ; then OUTPUTS="${OUTPUTS} --output ${MONITOR} --auto --right-of ${LAST_OUTPUT}";LAST_OUTPUT=${MONITOR}; fi
done

echo "${OUTPUTS}"
