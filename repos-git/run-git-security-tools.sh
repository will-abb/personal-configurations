#!/bin/bash

# Function to pause for user input
pause() {
    echo ""
    echo "Options: [Enter] to continue, [S] to skip next step, [Q] to quit"
    read -p "Your choice: " choice
    case "$choice" in
    [Qq]*)
        echo "Exiting."
        exit 0
        ;;
    [Ss]*)
        echo "Skipping next step."
        return 1
        ;;
    *) return 0 ;;
    esac
}

# Function to execute a command
run_command() {
    local cmd="$1"
    echo "Running: $cmd"
    eval "$cmd"
    pause
    return $?
}

# Verify user is in the root directory
verify_root_directory() {
    echo "Verifying current directory..."
    current_dir=$(pwd)
    echo "You are currently in: $current_dir"
    echo "This script must be run from the root directory of your project or repo."
    echo "Options: [Enter] to confirm, [S] to skip, [Q] to quit"
    read -p "Is this the correct directory? " choice
    case "$choice" in
    [Qq]*)
        echo "Exiting."
        exit 0
        ;;
    [Ss]*)
        echo "Skipping script execution."
        exit 0
        ;;
    *) echo "Continuing with script execution from: $current_dir" ;;
    esac
}

# Start script execution
verify_root_directory

# 1. Gitleaks
echo "### Running Gitleaks ###"
run_command "gitleaks dir . -v" || return
run_command "gitleaks git . -v" || return
run_command "gitleaks git --baseline-path .gitleaks_baseline.json" || return

# 2. Detect-Secrets
echo "### Running Git Secret (Detect-Secrets) ###"
run_command "detect-secrets scan --all-files > .secrets.baseline" || return
run_command "detect-secrets audit .secrets.baseline" || return

# 3. TruffleHog
echo "### Running TruffleHog ###"
run_command "trufflehog --no-update filesystem ." || return
run_command "trufflehog --no-update git file://." || return

# Ask user for remote repository URL for TruffleHog
echo "Enter the remote repository URL for TruffleHog or leave blank to skip:"
read remote_repo
if [[ -n "$remote_repo" ]]; then
    run_command "trufflehog --no-update $remote_repo" || return
fi

# Experimental GitHub object discovery
run_command "trufflehog --no-update github-experimental --repo $remote_repo --object-discovery" || return

# 4. Detect Secrets (Git-Secrets)
echo "### Running Detect Secrets (Git-Secrets) ###"
run_command "git-secrets --add-provider -- ~/repositories/bitbucket/williseed1/configs/repos-git/.custom_git_secrets_provider.sh" || return
run_command "git-secrets --scan -r ." || return

echo "All steps completed."
exit 0
