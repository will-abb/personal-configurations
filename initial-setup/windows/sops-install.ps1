# Variables
$version = "v3.9.1"
$binaryUrl = "https://github.com/getsops/sops/releases/download/$version/sops-$version.exe"
$checksumUrl = "https://github.com/getsops/sops/releases/download/$version/sops-$version.checksums.txt"
$binaryPath = "$env:USERPROFILE\sops.exe"
$checksumPath = "$env:USERPROFILE\sops.checksums.txt"

# Step 1: Download the SOPS binary
Write-Host "Downloading SOPS binary..."
Invoke-WebRequest -Uri $binaryUrl -OutFile $binaryPath

# Step 2: Download the checksum file
Write-Host "Downloading checksum file..."
Invoke-WebRequest -Uri $checksumUrl -OutFile $checksumPath

# Step 3: Move the binary to a directory in your PATH (e.g., C:\Windows\System32)
Write-Host "Moving SOPS binary to System32..."
Move-Item -Path $binaryPath -Destination "C:\Windows\System32\sops.exe"

# Step 4: Calculate the SHA-256 checksum of the downloaded binary
Write-Host "Calculating binary checksum..."
$binaryHash = Get-FileHash "C:\Windows\System32\sops.exe" -Algorithm SHA256
Write-Host "Binary Hash: " $binaryHash.Hash

# Step 5: Extract the expected checksum from the checksums file (just the hash)
Write-Host "Extracting expected checksum from checksum file..."
$expectedChecksum = (Select-String -Path $checksumPath -Pattern "sops-$version.exe").Matches[0].Groups[0].Value.Split(" ")[0].ToUpper()
Write-Host "Expected Checksum: " $expectedChecksum

# Step 6: Compare the checksums
Write-Host "Comparing checksums..."
if ($binaryHash.Hash -eq $expectedChecksum) {
    Write-Host "Checksum verification passed!" -ForegroundColor Green
} else {
    Write-Host "Checksum verification failed!" -ForegroundColor Red
}

# Step 7: Verify the installation by checking the SOPS version
Write-Host "Verifying SOPS installation..."
sops --version
