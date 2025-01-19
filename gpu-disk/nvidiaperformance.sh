#!/bin/bash
#  I have set this script to run every reboot As a cron job, I've also changed it to read execute only
# Enable Persistence Mode to keep the driver loaded
sudo nvidia-smi -pm 1

# Set PowerMizer mode to "Prefer Maximum Performance"
# This specific setting cannot be directly changed via nvidia-smi in all environments,
# and might require changing settings through NVIDIA X Server Settings or nvidia-settings command if available.

# Ensure Compute Mode is set to DEFAULT for flexibility
# Adjust this based on your specific needs, EXCLUSIVE_PROCESS might be beneficial for dedicated compute tasks
sudo nvidia-smi -c 0

# Optionally, reset the application clocks to ensure they are not limited by previous configurations
sudo nvidia-smi -rac

# Set the GPU to its maximum power limit to ensure maximum performance.
# Note: Replace [WATTS] with your GPU's maximum power capability in watts.
# You can find this with `nvidia-smi -q -d POWER`
# Example: sudo nvidia-smi -pl 250
# sudo nvidia-smi -pl [WATTS]

echo "Optimization settings applied."
