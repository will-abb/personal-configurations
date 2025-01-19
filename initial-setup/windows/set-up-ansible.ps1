# Allow this script to run without restrictions for the current session
Set-ExecutionPolicy Bypass -Scope Process -Force

# Check if pip is installed
if (!(Get-Command pip -ErrorAction SilentlyContinue)) {
    Write-Host "pip is not installed. Please install Python and pip before running this script."
    exit 1
}

# Install virtualenv if not already installed
Write-Host "Installing virtualenv..."
pip install virtualenv --user

# Find the path to the virtualenv executable dynamically
# List directories in the AppData\Roaming\Python path to get the correct Python version
$pythonBasePath = "$env:APPDATA\Python"
$pythonScriptsPath = Get-ChildItem -Path $pythonBasePath -Directory | Where-Object { Test-Path "$($_.FullName)\Scripts" } | Select-Object -ExpandProperty FullName -First 1

# Verify that the path was found, and virtualenv is available
if ($pythonScriptsPath -and (Test-Path "$pythonScriptsPath\Scripts\virtualenv.exe")) {
    $virtualenvExecutable = "$pythonScriptsPath\Scripts\virtualenv.exe"
    Write-Host "Found virtualenv executable at $virtualenvExecutable."
} else {
    Write-Host "Error: virtualenv executable not found. Please ensure virtualenv is installed correctly."
    exit 1
}

# Add the Python Scripts directory to the PATH permanently via the registry if not already present
if ($env:Path -notlike "*$pythonScriptsPath\Scripts*") {
    Write-Host "Adding $pythonScriptsPath\Scripts to PATH..."
    $currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
    $newPath = "$currentPath;$pythonScriptsPath\Scripts"
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::User)
    Write-Host "Path updated successfully."
} else {
    Write-Host "Path already contains $pythonScriptsPath\Scripts."
}

# Define the virtual environment directory dynamically based on the user's home directory
$virtualEnvDir = "$env:USERPROFILE\virtual_environments\ansible"

# Create the virtual environment using the dynamically located virtualenv executable
Write-Host "Creating virtual environment at $virtualEnvDir..."
& $virtualenvExecutable $virtualEnvDir

# Check the contents of the virtual environment directory to ensure it's created correctly
if (!(Test-Path "$virtualEnvDir\Scripts\Activate")) {
    Write-Host "Error: Virtual environment not created properly or Activate script is missing."
    exit 1
}

# Activate the virtual environment
$activateScript = "$virtualEnvDir\Scripts\Activate"
if (Test-Path $activateScript) {
    Write-Host "Activating the virtual environment..."
    & $activateScript
} else {
    Write-Host "Error: Activation script not found. Please ensure the virtual environment was created correctly."
    exit 1
}

# Install Ansible within the virtual environment
Write-Host "Installing Ansible in the virtual environment..."
pip install ansible

Write-Host "Ansible installation complete."
Write-Host "Your virtual environment is set up and ready to use!"
