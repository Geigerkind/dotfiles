#!/bin/bash

if grep -q closed /proc/acpi/button/lid/LID0/state ; then xrandr $(bash /home/shino/.config/xrandr_displays.sh false); echo "TEST"; else xrandr $(bash /home/shino/.config/xrandr_displays.sh true); fi
sleep 5s
i3-msg restart
