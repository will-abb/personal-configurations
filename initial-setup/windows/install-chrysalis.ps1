# install-chrysalis.ps1
<#
.SYNOPSIS
    Downloads and installs Chrysalis from the specified URL.
.DESCRIPTION
    This script downloads the Chrysalis installer executable from the provided URL and installs it silently.
.PARAMETER Url
    The URL to download the Chrysalis installer executable.
.PARAMETER Destination
    The directory where the Chrysalis installer will be saved temporarily.
.EXAMPLE
    .\install-chrysalis.ps1 -Url "https://github.com/keyboardio/Chrysalis/releases/download/v0.13.3/Chrysalis-0.13.3.Setup.exe"
#>

param (
    [string]$Url = "https://github.com/keyboardio/Chrysalis/releases/download/v0.13.3/Chrysalis-0.13.3.Setup.exe",
    [string]$Destination = "$env:TEMP\Chrysalis-Setup.exe"
)

# Function to download the executable file
function Download-Chrysalis {
    param ([string]$Url, [string]$DestinationPath)

    Write-Output "Downloading Chrysalis from $Url..."
    Invoke-WebRequest -Uri $Url -OutFile $DestinationPath
    Write-Output "Downloaded Chrysalis to $DestinationPath"
}

# Function to install the executable file silently
function Install-Chrysalis {
    param ([string]$ExecutablePath)

    Write-Output "Installing Chrysalis from $ExecutablePath..."
    Start-Process -FilePath $ExecutablePath -ArgumentList "/S" -NoNewWindow -Wait
    Write-Output "Chrysalis installation complete."
}

# Main process to download and install Chrysalis
function Main {
    param ([string]$Url, [string]$Destination)

    # Download Chrysalis executable
    Download-Chrysalis -Url $Url -DestinationPath $Destination

    # Install Chrysalis silently
    Install-Chrysalis -ExecutablePath $Destination

    # Clean up the installer file after installation
    Remove-Item -Path $Destination -Force
    Write-Output "Installer file removed from $Destination."
}

# Run the main function
Main -Url $Url -Destination $Destination
