#!/bin/bash

ENABLED=
DISABLED=

if makoctl mode | grep -q "default" ; then echo $ENABLED; else echo $DISABLED; fi
