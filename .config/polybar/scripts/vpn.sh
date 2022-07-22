#!/bin/bash

if [ $(ps aux | grep "[o]penconnect --protocol=gp" | wc -l) -gt 0 ]; then
   echo "On"
else
   echo "Off"
fi
