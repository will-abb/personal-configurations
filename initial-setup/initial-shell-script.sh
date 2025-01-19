#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

# Function to display messages with color formatting for better readability
log() {
    echo -e "\033[1;32m[INFO]\033[0m $1"
}

# Detect the Linux distribution
log "Detecting Linux distribution..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    log "Unable to detect the Linux distribution. Exiting."
    exit 1
fi

log "Detected distribution: $DISTRO"

# Update and upgrade system packages based on the distribution
log "Updating and upgrading system packages..."
if [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "kali" ]; then
    sudo apt update && sudo apt upgrade -y
elif [ "$DISTRO" = "fedora" ]; then
    sudo dnf update -y && sudo dnf upgrade -y
else
    log "Unsupported distribution. Exiting."
    exit 1
fi

# Refresh Snap packages (only available on Ubuntu) or Flatpak (for Fedora)
if [ "$DISTRO" = "ubuntu" ]; then
    log "Refreshing snap packages..."
    sudo snap refresh
elif [ "$DISTRO" = "fedora" ]; then
    log "Refreshing Flatpak packages..."
    sudo flatpak update -y
else
    log "Snap or Flatpak is not supported on this distribution. Skipping."
fi

# Install necessary packages based on the distribution
log "Installing necessary packages..."
if [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "kali" ]; then
    sudo apt install -y git vim terminator python3-pip python3-virtualenv xclip
elif [ "$DISTRO" = "fedora" ]; then
    sudo dnf install -y git vim terminator python3-pip python3-virtualenv xclip
fi

# Create necessary directories if they don't exist
log "Creating necessary directories..."
mkdir -p ~/virtual_environments ~/repositories/bitbucket/williseed1 ~/repositories/github

# Clone aws.el repository under the github directory if it doesn't exist
if [ ! -d ~/repositories/github/aws-mode ]; then
    log "Cloning aws-mode repository..."
    git clone https://github.com/will-abb/aws-mode ~/repositories/github/aws-mode/
else
    log "aws-mode repository already exists. Skipping."
fi

# Create a virtual environment for Ansible using Python 3 if not already created
if [ ! -d ~/virtual_environments/ansible ]; then
    log "Creating virtual environment for Ansible..."
    virtualenv -p python3 ~/virtual_environments/ansible
else
    log "Virtual environment for Ansible already exists. Skipping."
fi

# Activate the virtual environment and install Ansible
log "Activating the virtual environment and installing Ansible..."
source ~/virtual_environments/ansible/bin/activate
pip3 install -q ansible # '-q' for quiet output

# Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_rsa ]; then
    log "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -C "wiliamsbosch@gmail.com" -N "" -f ~/.ssh/id_rsa
    log "SSH key has been generated."
else
    log "SSH key already exists. Skipping."
fi

# Print instructions to copy SSH key to Bitbucket
log "Please copy the following SSH key to your Bitbucket account:"
cat ~/.ssh/id_rsa.pub
echo "Run the following command to copy the SSH key to clipboard:"
echo "cat ~/.ssh/id_rsa.pub | xclip -selection clipboard"
echo "Then paste it into your Bitbucket SSH keys settings."

# Wait for user confirmation to proceed
read -p "Have you copied the SSH key to Bitbucket? (yes to continue): " personal_confirm
while [ "$personal_confirm" != "yes" ]; do
    read -p "Please type 'yes' after you have copied the SSH key to Bitbucket: " personal_confirm
done

# Clone the Bitbucket Git repository using the SSH key if it doesn't exist
if [ ! -d ~/repositories/bitbucket/williseed1/configs ]; then
    log "Cloning the Bitbucket repository using the SSH key..."
    git -c core.sshCommand="ssh -i ~/.ssh/id_rsa" clone git@bitbucket.org:williseed1/configs.git ~/repositories/bitbucket/williseed1/configs
else
    log "Bitbucket repository already exists. Skipping."
fi

# Checkout specific branch or commit
cd ~/repositories/bitbucket/williseed1/configs/
log "Checking out the desired commit..."
git -c core.sshCommand="ssh -i ~/.ssh/id_rsa" fetch -q # Fetch updates quietly
git -c core.sshCommand="ssh -i ~/.ssh/id_rsa" checkout 6-8-2024

log "Setup completed successfully!"
