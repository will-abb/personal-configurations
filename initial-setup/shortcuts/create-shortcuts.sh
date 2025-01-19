#!/bin/bash

# Must use full path, no ~/
# Function to set multiple custom keyboard shortcuts in GNOME
set_custom_shortcuts() {
    local index=0
    local shortcuts=("$@")

    # Prepare the array format for gsettings
    local bindings_array="["
    for ((i = 0; i < ${#shortcuts[@]}; i++)); do
        bindings_array+="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$i/',"
    done
    bindings_array="${bindings_array%,}]"

    # Set the custom keybindings array
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$bindings_array"

    for shortcut in "${shortcuts[@]}"; do
        # Parse the argument
        IFS=':' read -r name command binding <<<"$shortcut"

        # Modify the command to use /bin/bash -c 'command'
        modified_command="/bin/bash -c '$command'"

        # Setting the shortcut details
        local keybinding_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$index/"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$keybinding_path name "$name"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$keybinding_path command "$modified_command"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$keybinding_path binding "$binding"

        ((index++))
    done

    echo "Custom shortcuts set successfully."
}

# Example usage with updated command format
set_custom_shortcuts \
    "screenshot-move-mark:~/repositories/bitbucket/williseed1/configs/initial-setup/shortcuts/move-mark-screenshot.sh:<Primary><Shift><Alt>O" \
    "CopyQ:/usr/bin/copyq:<Super>w" \
    "Transcription:~/repositories/bitbucket/williseed1/transcription/run-whisper.sh:<Super>r" \
    "EnableClick:~/repositories/bitbucket/williseed1/configs/initial-setup/shortcuts/enable-click-assist.sh:<Super>u" \
    "DisableClick:~/repositories/bitbucket/williseed1/configs/initial-setup/shortcuts/disable-click-assist.sh:<Super>x" \
    "chrome:/usr/bin/google-chrome:<Super>c" \
    "slack:/usr/bin/slack<Super>s" \
    "emacs:/usr/bin/emacs:<Super>e" \
    "terminator:/usr/bin/terminator:<Super>t" \
    "AudioToggle:~/repositories/bitbucket/williseed1/configs/initial-setup/shortcuts/change-sound-output-source.sh:<Super>j" \
    "SwitchWindowsNext:~/repositories/bitbucket/williseed1/configs/initial-setup/shortcuts/switch-windows-next.sh:<Super>n" \
    "SwitchWindowsPrevious:~/repositories/bitbucket/williseed1/configs/initial-setup/shortcuts/switch-windows-previous.sh:<Super>b" \
    "MoveMouseCenterClick:~/repositories/bitbucket/williseed1/configs/initial-setup/shortcuts/move-mouse-center-and-click.sh:<Super><Shift>M" \
    "MoveMouseBottomCenterClick:~/repositories/bitbucket/williseed1/configs/initial-setup/shortcuts/move-mouse-bottom-center-and-click.sh:<Super><Shift>B" \
    "ToggleVPN:~/repositories/bitbucket/williseed1/configs/initial-setup/shortcuts/toggle-vpn.sh:<Super>v" \
    "OpenChromium:/usr/bin/chromium-browser:<Super>g" \
    "OpenSettings:/usr/bin/gnome-control-center:<Super>i" \
    "Firefox:/usr/bin/firefox:<Super>f" \
    "OpenDownloads:/usr/bin/nautilus ~/Downloads:<Super>d" \
    "KillWhisperProcess:~/repositories/bitbucket/williseed1/transcription/kill-whisper.sh:<Shift><Super>r"
#letters that don't work i think: p,o
#if you ever recreate test just using the binaries command and not shell scripts
# If you have issues with shortcuts, make sure that when you're creating it you didn't mess up the path or something. Because it's a lot of text!!!
