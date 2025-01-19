#!/bin/bash

DOWNLOADS_DIR=~/Downloads
EXT_DIR=~/.local/share/gnome-shell/extensions

# Navigate to the Downloads directory
cd $DOWNLOADS_DIR

# Install extensions
gnome-extensions install --force InternetSpeedMonitorRishu.v8.shell-extension.zip
gnome-extensions install --force bluetooth-quick-connectbjarosze.gmail.com.v51.shell-extension.zip
gnome-extensions install --force highlight-focuspimsnel.com.v13.shell-extension.zip
gnome-extensions install --force openweather-extensionjenslody.de.v121.shell-extension.zip
gnome-extensions install --force ssm-gnomelgiki.net.v14.shell-extension.zip
gnome-extensions install --force VitalsCoreCoding.com.v69.shell-extension.zip
gnome-extensions install --force utcclockinjcristianrojas.github.com.v37.shell-extension.zip
gnome-extensions install --force clipboard-historyalexsaveau.dev.v45.shell-extension.zip
echo "Ignore if only one openweather fails, there are two installs"
echo "Extensions installed. Please restart GNOME Shell or log out and log back in to apply changes."
