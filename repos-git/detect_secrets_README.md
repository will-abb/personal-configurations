# Basic Usage of detect-secrets
**If there are issues when running the pre-commit that cause the baseline to be updated continuously/recursively without you being able to update and commit, the problem is because the pre-commit is running a different version than you are locally of the detect-secret tool.**

## Scanning and Auditing

### Scanning for Secrets
1. Create Baseline—only git tracked files:

```shell
detect-secrets scan > .secrets.baseline
```

2. Create Baseline—all files files:

```shell
detect-secrets scan --all-files > .secrets.baseline
```

3. Only Git-Tracked—update baseline:
```shell
detect-secrets scan --baseline .secrets.baseline
```

4. All Files—update baseline
```shell
detect-secrets scan --all-files --baseline .secrets.baseline
```

### Auditing Your Baseline
To label results in your baseline, potentially to configure the scanning plugins:

```shell
detect-secrets audit .secrets.baseline
```

## Inline Allowlisting
To exclude a false positive without creating a baseline:

```python
secret = "hunter2"      # pragma: allowlist secret
```

