# Allow this script to run without restrictions for the current session
Set-ExecutionPolicy Bypass -Scope Process -Force

# Set the path to the SSH key
$sshKeyPath = "$env:USERPROFILE\.ssh\id_rsa"

# Check if the SSH key file exists before proceeding
if (-not (Test-Path $sshKeyPath)) {
    Write-Host "Error: SSH key file not found at $sshKeyPath. Please ensure the file exists." -ForegroundColor Red
    exit 1
}

# Check if the SSH agent service is installed
try {
    $sshAgentService = Get-Service -Name ssh-agent -ErrorAction Stop
} catch {
    Write-Host "Error: SSH agent service not found. Please ensure OpenSSH is installed on your system." -ForegroundColor Red
    exit 1
}

# Ensure the SSH agent service is enabled to start automatically
if ($sshAgentService.StartType -ne 'Automatic') {
    Write-Host "Setting SSH agent service to start automatically..."
    Set-Service -Name ssh-agent -StartupType Automatic
}

# Start the SSH agent service if it is not running
if ($sshAgentService.Status -ne 'Running') {
    Write-Host "Starting SSH agent service..."
    Start-Service ssh-agent
}

# Escape backslashes for the regular expression
$escapedSshKeyPath = [regex]::Escape($sshKeyPath)

# Add the SSH key to the agent if not already added
if (-not (ssh-add -l 2>$null | Select-String -Pattern $escapedSshKeyPath)) {
    Write-Host "Adding SSH key to the agent..."
    ssh-add $sshKeyPath
}

# Verify the key is added
Write-Host "Current SSH keys in the agent:"
ssh-add -l
