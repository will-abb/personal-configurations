# Define Variables
$PythonVersion = "3.10.0" # Define the Python version to be installed
$InstallDir = "$env:USERPROFILE\Python$($PythonVersion.Replace('.', ''))" # Custom installation directory for Python
$VirtualEnvName = "python310_env" # Name of the virtual environment
$VirtualEnvDir = "$env:USERPROFILE\virtual_environments\$VirtualEnvName" # Directory to create the virtual environment

# URL for Python 3.10.0 installer
$PythonInstallerUrl = "https://www.python.org/ftp/python/$PythonVersion/python-$PythonVersion-amd64.exe"
$PythonInstallerPath = "$env:TEMP\python-$PythonVersion-installer.exe"

# Function to Download the Python Installer
function Download-PythonInstaller {
    Write-Output "Downloading Python $PythonVersion installer..."
    Invoke-WebRequest -Uri $PythonInstallerUrl -OutFile $PythonInstallerPath -UseBasicParsing
    Write-Output "Python $PythonVersion installer downloaded to $PythonInstallerPath"
}

# Function to Install Python
function Install-Python {
    Write-Output "Installing Python $PythonVersion to $InstallDir..."
    Start-Process -FilePath $PythonInstallerPath -ArgumentList "/quiet", "InstallAllUsers=1", "PrependPath=0", "TargetDir=$InstallDir" -NoNewWindow -Wait
    Write-Output "Python $PythonVersion installed to $InstallDir"
}

# Function to Create Virtual Environment
function Create-VirtualEnvironment {
    $PythonExe = "$InstallDir\python.exe"

    # Check if Python is installed
    if (!(Test-Path $PythonExe)) {
        Write-Error "Python executable not found at $PythonExe. Please check the installation."
        return
    }

    Write-Output "Creating virtual environment at $VirtualEnvDir..."
    & $PythonExe -m venv $VirtualEnvDir
    Write-Output "Virtual environment created at $VirtualEnvDir"
}

# Function to Activate Virtual Environment
function Activate-VirtualEnvironment {
    $ActivateScript = "$VirtualEnvDir\Scripts\Activate.ps1"
    if (Test-Path $ActivateScript) {
        Write-Output "Activating virtual environment..."
        & $ActivateScript
    } else {
        Write-Error "Activation script not found at $ActivateScript. Please check the virtual environment creation."
    }
}

# Download, Install Python, Create, and Activate Virtual Environment
Download-PythonInstaller
Install-Python
Create-VirtualEnvironment
Activate-VirtualEnvironment

# Cleanup
if (Test-Path $PythonInstallerPath) {
    Remove-Item $PythonInstallerPath -Force
    Write-Output "Cleaned up installer file: $PythonInstallerPath"
}

Write-Output "Python $PythonVersion installed and virtual environment $VirtualEnvName activated."
