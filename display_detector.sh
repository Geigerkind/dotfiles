#!/bin/bash

xrandr $(bash /home/shino/.config/xrandr_displays.sh)
xrandr --auto
sleep 5s
i3-msg restart
