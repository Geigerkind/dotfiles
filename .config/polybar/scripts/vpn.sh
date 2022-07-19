#!/bin/bash

if [ $(ps aux | grep "openconnect --protocol=gp" | wc -l) -gt 2 ]; then
   echo "On"
else
   echo "Off"
fi
