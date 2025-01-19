# Check if the current user is running the script as an administrator
if ( ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) ) {
    Write-Output "You are running this script as an administrator."
    Write-Output "Make sure to run as the user you want to affect, not as an admin."
    $response = Read-Host -Prompt "Continue? (yes/no)"
    if ($response -ne "yes") {
        Write-Output "Exiting script. Please run as the intended user."
        exit
    }
}

# Set up environment variables for the regular user
$regularUser = [System.Environment]::UserName
$regularUserProfile = [System.Environment]::GetFolderPath("UserProfile")

# Check and set HOME environment variable
$homeEnv = [System.Environment]::GetEnvironmentVariable("HOME", [System.EnvironmentVariableTarget]::User)
if (-not $homeEnv) {
    Write-Output "Setting up HOME environment variable for the regular user ($regularUser)..."
    [System.Environment]::SetEnvironmentVariable("HOME", "$regularUserProfile", [System.EnvironmentVariableTarget]::User)
} else {
    Write-Output "HOME environment variable is already set to: $homeEnv"
}

# Set up the PATH environment variable for the regular user
$emacsBinPath = "$regularUserProfile\.emacs.d\bin"
$ripgrepBinPath = "C:\ProgramData\chocolatey\bin\ripgrep"
$fdBinPath = "C:\ProgramData\chocolatey\bin\fd"
$copyqBinPath = "C:\Program Files (x86)\CopyQ"  # Path to CopyQ executable

$currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
$newPaths = "$emacsBinPath;$ripgrepBinPath;$fdBinPath;$copyqBinPath"

# Check if the paths already exist and update PATH
$pathsToAdd = @()
if ($currentPath -notmatch [regex]::Escape($emacsBinPath)) {
    $pathsToAdd += $emacsBinPath
}
if ($currentPath -notmatch [regex]::Escape($ripgrepBinPath)) {
    $pathsToAdd += $ripgrepBinPath
}
if ($currentPath -notmatch [regex]::Escape($fdBinPath)) {
    $pathsToAdd += $fdBinPath
}
if ($currentPath -notmatch [regex]::Escape($copyqBinPath)) {
    $pathsToAdd += $copyqBinPath
}

if ($pathsToAdd.Count -gt 0) {
    Write-Output "Adding the following paths to PATH: $($pathsToAdd -join ', ')..."
    [System.Environment]::SetEnvironmentVariable("Path", "$($pathsToAdd -join ';');$currentPath", [System.EnvironmentVariableTarget]::User)
} else {
    Write-Output "All required paths are already set. No changes needed."
}

# Inform the user about the changes
Write-Output "The following paths were added to your PATH environment variable:"
$pathsToAdd | ForEach-Object { Write-Output $_ }
