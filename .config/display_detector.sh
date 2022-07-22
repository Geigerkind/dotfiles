#!/bin/bash

function detect {
   if grep -q closed /proc/acpi/button/lid/LID0/state ; then xrandr $(bash /home/shino/.config/xrandr_displays.sh false); echo "TEST"; else xrandr $(bash /home/shino/.config/xrandr_displays.sh true); fi
}

detect
xrandr --auto
detect
sleep 5s
i3-msg restart
