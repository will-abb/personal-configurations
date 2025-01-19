# Post-Restart Script for Continuing WSL and Ubuntu Setup

# Set Execution Policy to allow the script to run without restrictions
Set-ExecutionPolicy Bypass -Scope Process -Force

# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator privileges. Please run PowerShell as Administrator." -ForegroundColor Red
    exit 1
}

# Check if WSL is installed and set WSL 3 as the default version
Write-Host "Configuring WSL to use version 2 as the default..."
wsl --set-default-version 2

# Install Ubuntu 22.04 if not already installed
$ubuntuInstalled = wsl --list --verbose | Select-String -Pattern 'Ubuntu-22.04'
if (-not $ubuntuInstalled) {
    Write-Host "Installing Ubuntu 22.04..."
    wsl --install -d Ubuntu-22.04
} else {
    Write-Host "Ubuntu 22.04 is already installed."
}

#update wsl
wsl --update

# Set Ubuntu 22.04 as the default WSL distribution
Write-Host "Setting Ubuntu 22.04 as the default distribution..."
wsl --set-default Ubuntu-22.04

Write-Host "WSL 2 with Ubuntu 22.04 setup is complete!"
