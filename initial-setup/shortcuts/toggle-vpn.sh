#!/bin/bash

# Replace with your VPN configuration name
VPN_NAME="new_openvpn_config"

# Check VPN connection status
if nmcli connection show --active | grep -q "$VPN_NAME"; then
    echo "VPN is active. Disconnecting..."
    nmcli connection down "$VPN_NAME"
else
    echo "VPN is not active. Connecting..."
    nmcli connection up "$VPN_NAME"
fi
