# Pre-Restart Script for Setting Up WSL and Ubuntu

# Set Execution Policy to allow the script to run without restrictions
Set-ExecutionPolicy Bypass -Scope Process -Force

# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator privileges. Please run PowerShell as Administrator." -ForegroundColor Red
    exit 1
}

# Set the path to the SSH key (this is retained for continuity, update or remove as necessary)
$sshKeyPath = "$env:USERPROFILE\.ssh\id_rsa"

# Check if the WSL feature is enabled
if (-not (Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online).State -eq 'Enabled') {
    Write-Host "Enabling the WSL feature..."
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
}

# Check if the Virtual Machine Platform feature is enabled
if (-not (Get-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online).State -eq 'Enabled') {
    Write-Host "Enabling the Virtual Machine Platform feature..."
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
}

# Prompt the user for a restart
$restartResponse = Read-Host "The system needs to be restarted to apply the changes. Would you like to restart now? (Y/N)"

if ($restartResponse -match '^[Yy]$') {
    Write-Host "Restarting the system to apply WSL and Virtual Machine Platform features..."
    Restart-Computer -Force
} else {
    Write-Host "Restart has been canceled. Please restart manually to continue the setup."
    Write-Host "After restarting, run the second script 'setup-wsl-post-restart.ps1' to complete the setup."
}
