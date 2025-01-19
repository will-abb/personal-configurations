# Git-Secrets Usage Guide
 The strength of this tool is the fact that you can customize your own checks or your own regular expressions. This tool is not maintained and has bugs so don't spend too much time trying to fix broken features.

> **IMPORTANT**: `git-secrets` does not detect secrets out-of-the-box. You must configure patterns manually.
> **WARNING**: Using the global flag applies configurations to all of your repositories.
> **WARNING**: I have not tested any pattern white/blacklisting, only providers.
> **WARNING**: PRECOMMIT Will ONLY BE TRIGGERED BY TRACKED files.
> **BUG**: When adding provider file make sure to *NOT* include `-- cat`, it's currently broken.
> **BUG**: You must include either the path or period in scans: `git-secrets --scan -r .` or `git-secrets --scan -r /path/`.
> **BUG**: Scanning repo history does not work. I've already spen enough time trying to fix the problem, don't use it for that.
> **BUG**: Parameters --untracked, --cached, and --no-index don't work.

## Basic Repository Setup
To set up `git-secrets` in your repository and ensure commits are checked for secrets. Not needed to run the tool.
(Note: done automatically if setting up a pre-commit hook)

**Initialize `git-secrets`:**
   ```shell
   git-secrets --install
   ```

## Adding Custom Prohibited Patterns
*You can add patterns, but it's best just to add a provider file.*
To add custom patterns for scanning specific types of PII or other secrets:

1. **Add a prohibited pattern:**
   ```shell
   git-secrets --add 'regex_for_secret'
   git-secrets --add 'password\s*=\s*.+'
   ```

2. **Preferred Method - Add a Provider:**
   This method adds patterns from the specified file.
   ```shell
   git-secrets --add-provider -- ~/repositories/bitbucket/williseed1/configs/repos-git/.custom_git_secrets_provider.sh
   ```

## Scanning and Preventing Secrets

- **Scan Current File Only (doesn't do directories, use globbing for that):**
  ```shell
  git-secrets --scan /path/to/file
  ```

- **Recursive Scanning All Types of Files in Subdirectories (Including Untracked Files):**
  ```shell
  git-secrets --scan -r /path/to/directory
  git-secrets --scan -r .
  ```

- **List Current Configuration:**
  ```shell
  git-secrets --list
  ```

- **Allow Specific Patterns to Ignore False Positives:**
  ```shell
  git-secrets --add --allowed 'my regex pattern'
  ```

### Detailed Scanning Options

- **Scan Specific Files:**
  ```shell
  git-secrets --scan /path/to/file
  ```

- **Scan Multiple Files:**
  ```shell
  git-secrets --scan /path/to/file /path/to/another/file
  ```

- **Globbing Scan:**
  ```shell
  git-secrets --scan /path/to/directory/*
  ```

- **Scan from stdin:**
  ```shell
  echo 'hello!' | git-secrets --scan -
  ```

### Ignoring False Positives

- **General Guidelines:**
  To ignore patterns, add regular expressions to a `.gitallowed` file in the repository's root. Lines starting with `#` (comments) and empty lines are skipped. See this folder for an example of the formatting that must be followed

- **Handling False Positives:**
  ```shell
  git commit --no-verify
  ```
  This command bypasses the pre-commit hook and allows committing.

- **Mitigation Steps: have not been tested**
  - Mark false positives as allowed using `git config --add secrets.allowed` ...
  - List configured patterns: `git config --get-all secrets.patterns`
  - List allowed patterns: `git config --get-all secrets.allowed`
  - Use `--no-verify` for one-time false positives.

## Important Notes

- The effectiveness of `git-secrets` relies heavily on the patterns you configure.
- To remove a provider, edit the `.git/config` file and remove the relevant section from `[secrets]`.

**To add to all repos:**
```shell
git-secrets --add-provider --global ~/repositories/bitbucket/williseed1/configs/repos-git/.custom_git_secrets_provider.sh
```

### Testing
1. For `echo 'DB[_-]?USERNAME ?[=:].*|db[_-]?username ?[=:].*'` use:
   ```
   db-username=
   db username=
   dbusername:
   db_username
   ```
