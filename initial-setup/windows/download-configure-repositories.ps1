# Function to clone a repository and checkout a specific branch
function Clone-And-Checkout ($repoUrl, $cloneDir, $branchName) {
    # Check if the directory already exists
    if (Test-Path -Path $cloneDir) {
        Write-Host "Repository already exists at $cloneDir. Skipping clone."
        # Navigate to the repository directory
        Set-Location -Path $cloneDir
        # Fetch and checkout the specified branch
        git fetch origin
        git checkout $branchName
    } else {
        # Clone the repository to the specified directory
        Write-Host "Cloning $repoUrl to $cloneDir..."
        git clone $repoUrl $cloneDir
        # Navigate to the repository directory
        Set-Location -Path $cloneDir
        # Checkout the specified branch
        Write-Host "Checking out branch $branchName..."
        git checkout $branchName
    }
}

# Clone and checkout for the first repository
$repo1 = "git@bitbucket.org:williseed1/.doom.d.git"
$cloneDir1 = "$HOME\.doom.d"
$branch1 = "windows-org-config"
Clone-And-Checkout $repo1 $cloneDir1 $branch1

# Clone and checkout for the second repository
$repo2 = "git@bitbucket.org:williseed1/configs.git"
$cloneDir2 = "$HOME\repositories\bitbucket\williseed1\configs"
$branch2 = "6-8-2024"
Clone-And-Checkout $repo2 $cloneDir2 $branch2

# Clone and checkout for the third repository
$repo3 = "git@bitbucket.org:williseed1/security-routines.git"
$cloneDir3 = "$HOME\repositories\bitbucket\williseed1\security-routines"
$branch3 = "6-8-2024"
Clone-And-Checkout $repo3 $cloneDir3 $branch3

Write-Host "All repositories processed."
