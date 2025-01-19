# Install Chocolatey if not installed
function Check-Chocolatey {
    Write-Output "Checking if Chocolatey is installed..."
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Output "Chocolatey is not installed, exiting..."
        exit 1
    } else {
        Write-Output "Chocolatey is already installed."
    }
}

# Install Chocolatey if not installed
Check-Chocolatey

# List of required packages
$packages = @("git", "emacs", "ripgrep", "fd", "llvm", "copyq", "cmake", "awscli", "awssamcli")

Write-Output "Installing required packages: $($packages -join ', ')"
foreach ($package in $packages) {
    choco install $package -y
}
