# Repository Security Tools

This document provides a brief guide to the git security tools used to detect secrets in repositories. The tools covered are `Gitleaks`, `Git Secret`, `TruffleHog`, and `Detect Secrets`.

**use run-git-security-tools.sh to interactively run all tools**
## 1. Gitleaks

**Scan a directory:**
```bash
gitleaks dir . -v
```

**Scan a Git repository:**
```bash
gitleaks git . -v
```

**Scan with baseline:**
```bash
gitleaks git --baseline-path .gitleaks_baseline.json
```

## 2. Git Secret (via Detect-Secrets)

**Scan all files and create a baseline:**
```bash
detect-secrets scan --all-files > .secrets.baseline
```

**Audit the baseline:**
```bash
detect-secrets audit .secrets.baseline
```

## 3. TruffleHog

**Scan a directory recursively:**
```bash
th filesystem .
```

**Scan a local Git repository:**
```bash
th git file://. # I think just using dot works
```

**Scan a remote Git repository:**
```bash
th git https://github.com/user/repository.git
```

**Experimental GitHub object discovery:**
```bash
th github-experimental --repo https://github.com/user/repository.git --object-discovery
```

## 4. Detect Secrets (via Git-Secrets)

**Add a custom provider:**
```bash
git-secrets --add-provider -- ~/repositories/bitbucket/williseed1/configs/repos-git/.custom_git_secrets_provider.sh
```

**Scan a directory recursively:**
```bash
git-secrets --scan -r .
```

## Notes
- The alias `th` is used for TruffleHog in these examples.
