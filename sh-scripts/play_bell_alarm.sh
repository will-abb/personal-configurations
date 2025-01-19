#!/bin/bash
# This is for pomodoro alarm.

# Path to the MP3 file
FILE_PATH="$HOME/Music/creepy-church-bell-33827.mp3"

# Check if the file exists
if [ -f "$FILE_PATH" ]; then
    timeout 10 mpg123 "$FILE_PATH"
else
    echo "File does not exist: $FILE_PATH"
    exit 1
fi
