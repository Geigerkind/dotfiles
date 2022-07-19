#!/bin/bash

# see man zscroll for documentation of the following parameters
zscroll -l 30 \
        --delay 0.1 \
        --scroll-padding "  " \
        --match-command "python `dirname $0`/spotify_status.py -f '{play_pause}'" \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 0" \
        --update-check true "python `dirname $0`/spotify_status.py -f '{artist} - {song}'" &

wait
