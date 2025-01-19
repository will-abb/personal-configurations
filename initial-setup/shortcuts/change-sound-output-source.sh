#!/bin/bash

# Function to detect the operating system
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME=$ID
    else
        echo "Unable to detect the operating system."
        exit 1
    fi
}

# Dynamically find the names of your sink inputs based on OS
set_sink_variables() {
    if [ "$OS_NAME" = "fedora" ]; then
        HEADPHONES_SINK=$(pactl list short sinks | grep -i 'bluez_output' | awk '{print $2}' | head -n 1)
        SPEAKERS_SINK=$(pactl list short sinks | grep -i 'alsa_output' | awk '{print $2}' | head -n 1)
    elif [ "$OS_NAME" = "ubuntu" ]; then
        HEADPHONES_SINK=$(pactl list short sinks | grep 'bluez_sink' | awk '{print $2}' | head -n 1)
        SPEAKERS_SINK=$(pactl list short sinks | grep 'alsa_output.pci' | awk '{print $2}' | head -n 1)
    else
        echo "Unsupported operating system: $OS_NAME"
        exit 1
    fi
}

# Validate sink values to ensure they're not empty
validate_sinks() {
    if [ -z "$HEADPHONES_SINK" ]; then
        echo "Error: Headphones sink not found. Please ensure headphones are connected."
        exit 1
    fi

    if [ -z "$SPEAKERS_SINK" ]; then
        echo "Error: Speakers sink not found."
        exit 1
    fi
}

# Find the current default sink
get_current_sink() {
    CURRENT_SINK=$(pactl info | grep 'Default Sink' | awk -F': ' '{print $2}' | xargs)
}

# Function to switch the sink and move all audio threads to the new sink
switch_sink() {
    echo "Setting default sink to $1"
    pactl set-default-sink "$1"

    # Move all audio streams to the new sink
    SINK_INPUTS=$(pactl list short sink-inputs | awk '{print $1}')
    if [ -z "$SINK_INPUTS" ]; then
        echo "No active sink inputs to move."
    else
        echo "$SINK_INPUTS" | while read -r input; do
            pactl move-sink-input "$input" "$1" || echo "Failed to move input $input"
        done
    fi
    echo "Switched to $1."
}

# Main script execution
detect_os
set_sink_variables
validate_sinks
get_current_sink

# Toggle the default sink
if [ "$CURRENT_SINK" = "$HEADPHONES_SINK" ]; then
    switch_sink "$SPEAKERS_SINK"
else
    switch_sink "$HEADPHONES_SINK"
fi
