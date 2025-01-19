# Allow user to run  scripts with remote signed restrictions
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Allow this script to run without restrictions for the current session
Set-ExecutionPolicy Bypass -Scope Process -Force

# Ensure Chocolatey is installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'));
}

# Install Git using Chocolatey if not already installed
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    choco install git -y
}

# Create SSH keys with passphrase and add to SSH agent
$sshKeyPath = "$env:USERPROFILE\.ssh\id_rsa"
$sshKeyComment = "williamsbosch@gmail.com"

# Create .ssh directory if it doesn't exist
if (!(Test-Path $env:USERPROFILE\.ssh)) {
    New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.ssh"
}

Write-Host "Generating SSH key..."
ssh-keygen -t rsa -b 4096 -C $sshKeyComment -f $sshKeyPath

# Enable and start the SSH agent service
Write-Host "Enabling SSH agent service..."
Set-Service -Name ssh-agent -StartupType Automatic
Start-Service -Name ssh-agent

# Start SSH agent and add the SSH key
Write-Host "Starting SSH agent..."
ssh-agent -s | Out-Null
ssh-add $sshKeyPath

# Set the GIT_SSH environment variable permanently for the current user
Write-Host "Setting GIT_SSH environment variable permanently..."
setx GIT_SSH "C:\Windows\System32\OpenSSH\ssh.exe" /M

# Create directories
$baseDir = "$env:USERPROFILE\repositories\bitbucket"
$virtualEnvDir = "$env:USERPROFILE\virtual_environments\ansible"

New-Item -ItemType Directory -Path $baseDir -Force
New-Item -ItemType Directory -Path $virtualEnvDir -Force

# Install Python using Chocolatey if not already installed
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    choco install python -y
}

# Inform the user to open a new shell for the next steps
Write-Host "Please open a new shell and run the following commands:"
Write-Host "1. pip install virtualenv"
Write-Host "2. virtualenv $virtualEnvDir"
Write-Host "3. .\$virtualEnvDir\Scripts\Activate"
Write-Host "4. pip install ansible"