#!/bin/bash

# Script to toggle the 'dwell-click-enabled' setting for the GNOME desktop environment
# For the shortcut this script won't work, just use the 2 commands (enable and disable)
# and bind each to a different keybind

# Get the current state of 'dwell-click-enabled'
current_state=$(gsettings get org.gnome.desktop.a11y.mouse dwell-click-enabled)

# Check and toggle the state
if [ "$current_state" == "true" ]; then
    # If currently enabled, disable it
    gsettings set org.gnome.desktop.a11y.mouse dwell-click-enabled false
    echo "Dwell Click has been disabled."
else
    # If currently disabled, enable it
    gsettings set org.gnome.desktop.a11y.mouse dwell-click-enabled true
    echo "Dwell Click has been enabled."
fi
