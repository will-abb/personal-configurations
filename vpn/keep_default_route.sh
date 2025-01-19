#!/bin/bash
## sudo nano /etc/NetworkManager/dispatcher.d/99-route-metric
## sudo chmod +x /etc/NetworkManager/dispatcher.d/99-route-metric
## sudo systemctl restart NetworkManager

# Adjust your 3 interfaces according to the output of "ip a"
VPN_INTERFACE="tun0"
WIRED_INTERFACE="eno1"
WIRELESS_INTERFACE="wlp0s20f3"
PREFERRED_GATEWAY="10.0.0.1"
PREFERRED_METRIC="10"
LOG_FILE="/var/log/route-metric.log"

function log_message() {
    local message=$1
    echo "$(date) - $message" >>$LOG_FILE
}

function determine_preferred_interface() {
    local wired_status
    local wireless_status

    # Check if the wired interface is operational
    wired_status=$(ip a show $WIRED_INTERFACE | grep -o "LOWER_UP")

    # Check if the wireless interface is operational
    wireless_status=$(ip a show $WIRELESS_INTERFACE | grep -o "LOWER_UP")

    if [[ "$wired_status" == "LOWER_UP" ]]; then
        echo "$WIRED_INTERFACE"
        log_message "Wired interface $WIRED_INTERFACE is active."
    elif [[ "$wireless_status" == "LOWER_UP" ]]; then
        echo "$WIRELESS_INTERFACE"
        log_message "Wireless interface $WIRELESS_INTERFACE is active."
    else
        log_message "No active interface found. Defaulting to $WIRED_INTERFACE."
        echo "$WIRED_INTERFACE" # Fallback to wired
    fi
}

function add_route_with_metric() {
    local interface=$1
    local gateway=$2
    local metric=$3
    # Add a new default route with the desired metric without deleting the existing one
    sudo ip route add default via $gateway dev $interface metric $metric
    log_message "Added route via $gateway dev $interface metric $metric"
}

log_message "Script called with interface: $1 and action: $2"

PREFERRED_INTERFACE=$(determine_preferred_interface)

if [ "$2" == "vpn-up" ] && [ "$1" == "$VPN_INTERFACE" ]; then
    # VPN has connected, add preferred route with lower metric.
    add_route_with_metric "$PREFERRED_INTERFACE" "$PREFERRED_GATEWAY" "$PREFERRED_METRIC"
elif [ "$2" == "vpn-down" ] && [ "$1" == "$VPN_INTERFACE" ]; then
    # VPN has disconnected, no action needed if we're not deleting the route.
    log_message "VPN disconnected, no action taken."
fi
