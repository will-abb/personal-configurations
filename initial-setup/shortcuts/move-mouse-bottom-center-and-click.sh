#!/bin/bash

# Get the ID of the currently active window
ACTIVE_WINDOW=$(xdotool getactivewindow)

# Get the geometry of the active window
WINDOW_GEOMETRY=$(xdotool getwindowgeometry --shell $ACTIVE_WINDOW)

# Extract the width and height of the window
WIDTH=$(echo "$WINDOW_GEOMETRY" | grep WIDTH | cut -d '=' -f 2)
HEIGHT=$(echo "$WINDOW_GEOMETRY" | grep HEIGHT | cut -d '=' -f 2)

# Get the window position
WINDOW_X=$(echo "$WINDOW_GEOMETRY" | grep X | cut -d '=' -f 2)
WINDOW_Y=$(echo "$WINDOW_GEOMETRY" | grep Y | cut -d '=' -f 2)

# Calculate the center coordinates of the window
CENTER_X=$((WIDTH / 2))
CENTER_Y=$((HEIGHT / 2))

# Calculate the center coordinates at the bottom of the window
BOTTOM_Y=$((HEIGHT - 1))

# Calculate the absolute position for the mouse to move to the center first
CENTER_MOUSE_X=$((WINDOW_X + CENTER_X))
CENTER_MOUSE_Y=$((WINDOW_Y + CENTER_Y))

# Calculate the absolute position for the mouse to move to the bottom center
BOTTOM_MOUSE_X=$((WINDOW_X + CENTER_X))
BOTTOM_MOUSE_Y=$((WINDOW_Y + BOTTOM_Y))

# Move the mouse to the center of the window first
xdotool mousemove $CENTER_MOUSE_X $CENTER_MOUSE_Y

# Then move the mouse to the bottom center of the window and perform a left click
xdotool mousemove $BOTTOM_MOUSE_X $BOTTOM_MOUSE_Y

# Add a small delay
sleep 0.1

# Perform a left click
xdotool mousedown 1
sleep 0.1
xdotool mouseup 1
