# Check if Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Chocolatey is not installed. Please install Chocolatey first."
    exit
}

# Check if required Chocolatey packages are installed
$packages = @("git", "emacs", "ripgrep", "fd", "llvm")
$installedPackages = choco list | ForEach-Object { $_.Split(' ')[0] }
$missingPackages = @()

foreach ($package in $packages) {
    if (-not ($installedPackages -contains $package)) {
        $missingPackages += $package
    }
}

if ($missingPackages.Count -gt 0) {
    Write-Output "The following packages are missing: $($missingPackages -join ', '). Please install them using Chocolatey."
    exit
}

# Install Doom Emacs for the regular user
$regularUser = [System.Environment]::UserName
$regularUserProfile = [System.Environment]::GetFolderPath("UserProfile")

if (-not (Test-Path "$regularUserProfile\.emacs.d")) {
    git clone https://github.com/hlissner/doom-emacs "$regularUserProfile\.emacs.d"
}

Write-Output "Doom Emacs installed. Please run the installation commands in Git Bash or WSL for the regular user."
Write-Output "If you encounter any issues, ensure all necessary environment variables are set."
