#!/bin/bash
# use with gnome extension: focus-highlighting:
# It's very important to remember that this command only works if there are multiple workspaces, which means you must have apps in another workspace or it will not switch

# Define the applications to cycle through
declare -a apps=("google-chrome" "xfreerdp.xfreerdp" "Chromium" "firefox" "Navigator.firefox" "emacs" "terminator" "slack" "gnome-boxes" "waterfox" "Navigator.waterfox")

# Debug: Show all matching windows
echo "Matching Windows:"
wmctrl_output=$(wmctrl -lx)
echo "$wmctrl_output"
echo ""

# Get the current active window ID, ensuring it's strictly numerical, stripping leading zeros
current_window=$(xprop -root _NET_ACTIVE_WINDOW | grep -oP "(?<=window id # )0x\w+" | sed 's/^0x0*/0x/')

# Display the current window ID for debugging
echo "Current Window ID: $current_window"

# Get the current workspace ID
current_workspace=$(wmctrl -d | awk '$2 == "*" {print $1}')

# Get a list of all windows in the current workspace, filtering out the applications not to include, stripping leading zeros
windows=($(echo "$wmctrl_output" | awk -v ws="$current_workspace" '$2 == ws' | awk '{print $1, $3}' | grep -P "$(
    IFS='|'
    echo "${apps[*]}"
)" | awk '{print $1}' | sed 's/^0x0*/0x/'))

# Debug: Show the list of window IDs being cycled through
echo "Window IDs in current workspace: ${windows[@]}"

# Find the current window in the list and determine the previous window to focus
found=false
for i in "${!windows[@]}"; do
    if [[ "${windows[$i]}" == "$current_window" ]]; then
        prev_index=$(((i - 1 + ${#windows[@]}) % ${#windows[@]})) # Calculate previous index in a circular list
        prev_window=${windows[$prev_index]}
        found=true
        break
    fi
done

if [[ "$found" == true ]]; then
    # Focus the previous window
    wmctrl -ia "$prev_window"

    echo "Switched to window $prev_window with blink effect."
else
    echo "Current window not found in the list or no other windows available to switch."
fi
