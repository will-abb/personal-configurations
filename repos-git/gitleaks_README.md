# Gitleaks Command Usage Guide

## Overview
Gitleaks is a tool for detecting secrets like passwords, API keys, and tokens in git repos, files, and more. It's very good at scanning repository history.

## Commands

The primary commands available in Gitleaks are as follows:
- `git`: Scan git repositories for secrets.
- `dir`: Scan directories or files for secrets.
- `stdin`: Detect secrets from stdin.
- `completion`: Generates autocompletion scripts for shells like bash, zsh, or fish.

## Usage

### Scanning Directories or Files
To scan directories or files without involving git history, use the `dir` command:
```shell
gitleaks dir  <path-to-directory-or-file>
```

### Scanning Git Repositories
To detect secrets in your codebase, you can use the `git` command:

For specific path:
```shell
gitleaks git  <path-to-directory-or-repo>
```

If in root of repository:
```shell
gitleaks git
```

Show the actual commit info:
```shell
gitleaks git --verbose
```

To specify a range of commits to scan in a git repository, use the `--log-opts` flag:
```shell
gitleaks git --log-opts="--all commitA..commitB"
```

### Streaming Data
To stream data to Gitleaks for scanning, use the `stdin` command:
```shell
cat some_file | gitleaks stdin
```

### Creating and Using Baselines

To create a baseline report:
```shell
gitleaks git --report-path .gitleaks_baseline.json
```

To scan using a baseline, ensuring only new findings are reported:
```shell
gitleaks git --baseline-path .gitleaks_baseline.json
```

### Verifying Findings

If you have a finding to verify, use the git log:
```shell
git log -L <StartLine>,<EndLine>:<File> <Commit>
```

## Flags

Gitleaks provides several flags to customize its behavior:
- `-b, --baseline-path string`: Path to a baseline report.
- `-c, --config string`: Path to the Gitleaks configuration file.
- `-l, --log-level string`: Log level for the output.
- `-f, --report-format string`: Format of the output report.
- `-r, --report-path string`: Path to save the report.
- `-v, --verbose`: Enable verbose output.

## Additional Configuration

### Inline Allowlisting

To allowlist a secret directly in the code, add a comment:
```python
secret = "example"  # gitleaks:allow
```
Adding `# gitleaks:allow` as a comment after a secret will ignore that specific line in the scan.

### .gitleaksignore
You can ignore findings by creating a `.gitleaksignore` file in your repo and adding the fingerprint of the finding you want to ignore. It should be the value of the fingerprint key:
```plaintext
0f4cc22064b38154fd57b22a6bef319bf32b6a50:.secrets.baseline:generic-api-key:123
```
The fingerprint uniquely identifies a secret. Add the exact fingerprint value to `.gitleaksignore` to suppress the specific finding.

