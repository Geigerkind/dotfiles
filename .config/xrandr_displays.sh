#!/bin/bash

USE_BUILTIN_DISPLAY=${1}

OUTPUTS="--output eDP-1-1 --off"
LAST_OUTPUT="eDP-1-1"
if [ "${USE_BUILTIN_DISPLAY}" = "true" ]; then
   OUTPUTS="--output eDP-1-1 --mode 1920x1080"
fi

MONITORS=("DP-0" "DP-1" "DP-2" "HDMI-0" "DVI-I-2-1" "DVI-I-3-2")
XRANDR_OUTPUT=$(xrandr)
for MONITOR in "${MONITORS[@]}"; do
      if echo "${XRANDR_OUTPUT}" | grep -q "${MONITOR} connected 3840x2160" ; then OUTPUTS="${OUTPUTS} --output ${MONITOR} --mode 2560x1440 --right-of ${LAST_OUTPUT}";LAST_OUTPUT=${MONITOR}; 
      elif echo "${XRANDR_OUTPUT}" | grep -q "${MONITOR} connected primary 3840x2160" ; then OUTPUTS="${OUTPUTS} --output ${MONITOR} --mode 2560x1440 --right-of ${LAST_OUTPUT}";LAST_OUTPUT=${MONITOR}; 
      elif echo "${XRANDR_OUTPUT}" | grep -q "${MONITOR} connected 2560x1440" ; then OUTPUTS="${OUTPUTS} --output ${MONITOR} --mode 2560x1440 --right-of ${LAST_OUTPUT}";LAST_OUTPUT=${MONITOR}; 
      else
        if echo "${XRANDR_OUTPUT}" | grep -q "${MONITOR} connected" ; then OUTPUTS="${OUTPUTS} --output ${MONITOR} --auto --right-of ${LAST_OUTPUT}";LAST_OUTPUT=${MONITOR}; fi
      fi
   done


echo "${OUTPUTS}"
