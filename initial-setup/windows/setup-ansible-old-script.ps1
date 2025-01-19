# Allow this script to run without restrictions for the current session
Set-ExecutionPolicy Bypass -Scope Process -Force

# Set the virtual environment directory based on the user profile environment variable
$virtualEnvDir = "$env:USERPROFILE\virtual_environments\ansible"

# Install virtualenv
pip install virtualenv

# Print the PATH before modification
Write-Output "PATH before modification: $env:PATH"

# Add the Scripts directory to the PATH temporarily
$pythonScriptsDir = "C:\Python312\Scripts"
$env:PATH += ";$pythonScriptsDir"

# Print the PATH after adding Scripts directory
Write-Output "PATH after adding Scripts directory: $env:PATH"

# Verify the Scripts directory is in the PATH
if (Test-Path "$pythonScriptsDir\virtualenv.exe") {
    Write-Output "virtualenv found in Scripts directory."

    # Create a virtual environment in the specified directory
    & "$pythonScriptsDir\virtualenv.exe" $virtualEnvDir
} else {
    Write-Output "virtualenv.exe not found in Scripts directory. Using Python interpreter to run virtualenv."

    # Create a virtual environment in the specified directory using Python interpreter
    python -m virtualenv $virtualEnvDir
}

# Set the new PATH variable permanently
$oldPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
$newPath = $oldPath + ";$pythonScriptsDir"
[System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)

# Print the PATH after setting it permanently
Write-Output "PATH after setting it permanently: $newPath"

# Activate the virtual environment
$activateScript = "$virtualEnvDir\Scripts\Activate.ps1"
if (Test-Path $activateScript) {
    Write-Output "Activating virtual environment."
    & $activateScript
} else {
    Write-Output "Activation script not found: $activateScript"
}

# Install Ansible within the virtual environment
pip install ansible
