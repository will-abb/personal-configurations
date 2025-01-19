#!/usr/bin/env sh

# Number of times to repeat the process
NUM_REPEATS=0 ##CHANGE!

for i in $(seq 1 $NUM_REPEATS); do

    # vim go down 31 lines (full screen)
    xdotool key --delay 100 3
    xdotool key --delay 100 1
    xdotool key --delay 100 j

    # vim mark line
    xdotool key --delay 100 m
    xdotool key --delay 100 z
    sleep 1

    # Define the path and filename for the screenshot
    IMAGE_DIR="~/.org-jira/audit/images/"
    EPOCH_TIME=$(date +%s%3N)
    FILENAME="${IMAGE_DIR}${EPOCH_TIME}.png"

    # Take a screenshot and save it
    gnome-screenshot -w -f "$FILENAME"
    sleep 1

    # open buffers
    xdotool key --delay 100 space
    xdotool key --delay 100 b
    xdotool key --delay 100 B
    sleep 1

    # jira ticket 7427 and 'enter'
    xdotool key --delay 100 7
    xdotool key --delay 100 4
    xdotool key --delay 100 3
    xdotool key --delay 100 6
    xdotool key --delay 200 Return
    xdotool key --delay 200 Escape
    xdotool key --delay 200 o
    sleep 1

    # Type the Org mode block for the image
    xdotool type --delay 100 "[[file:${FILENAME}]]"
    xdotool key --delay 100 Return
    xdotool key --delay 100 Return
    xdotool key --delay 200 Escape

    # fold images
    xdotool key --delay 100 z
    xdotool key --delay 100 i
    sleep 0.5

    # cycle vterm
    xdotool key --delay 100 space
    xdotool key --delay 100 t
    xdotool key --delay 100 T
    sleep 1

    # got to marked location
    xdotool key --delay 100 apostrophe
    xdotool key --delay 100 z
    sleep 1

done
