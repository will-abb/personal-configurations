# TruffleHog Usage Guide

This README provides instructions on using TruffleHog, a tool for detecting secrets in code. The focus is on basic usage for scanning AWS services, local and remote code repositories, and Docker images.

## Notes and Updates

- **Alias Created**: An alias `th` has been set up for the `trufflehog` command with the `--no-update` flag permanently included. You can now use `th` instead of `trufflehog` to avoid specifying `--no-update` repeatedly. This has been done because the binary tries to update itself, but it needs to run a sudo to do that but I don't want to do that.

*Running the command without any argument brings a wizard which allows you to be able to scan many, many different tools:*

```shell
trufflehog
```

## Difference Between Verified and Unverified Secrets

- **Verified Secrets**: These are actively validated against their respective services or APIs to confirm they are live and functional. For example, TruffleHog may attempt an API call to confirm that an AWS access key works. Verified secrets indicate actionable and immediate vulnerabilities.
- **Unverified Secrets**: These are potential matches based on patterns, entropy, or regex rules but are not validated against any service. They may include false positives or inactive credentials that require manual review.

## Scanning Local Directories
For scanning a directory (not tied to a Git repository), navigate to the desired directory and run:

```shell
th filesystem .

th filesystem path/to/your/directory
```
*Path parameter must be provided*

**Note**: The `filesystem` option scans the directory as-is. It does not analyze Git history or commits. Use the `git` option for repository scanning.

## Scanning Local Git Repositories
To scan a Git repository (including its entire commit history), use the following command:

```shell
th git file://path/to/local/repo
```

Ensure the `file://` prefix is included when specifying a local Git repository.

## Scanning Remote Repositories
To scan a remote repository, use the following command:

```shell
th git https://github.com/user/repository.git
```

Replace `https://github.com/user/repository.git` with the URL of the remote repository.

### Example: Checking for Deleted Commits
To scan a repository for deleted commits and cross-fork object references:

```shell
th github-experimental --repo https://github.com/user/repository.git --object-discovery
```

## Scanning Docker Images
TruffleHog can scan Docker images for secrets. Use the following command:

```shell
th docker://<image_name>:<tag>
```

Replace `<image_name>` and `<tag>` with the name and tag of the Docker image, respectively.

## Scanning AWS S3
To scan an AWS S3 service, you'll need to point TruffleHog to the relevant configuration files or environment variables where AWS credentials are stored.

### Scanning a Specific S3 Bucket
To scan a specific bucket using locally set credentials or instance metadata if on an EC2 instance, use the following command:
```shell
th s3 --bucket=<bucket-name>
```

### Scanning Multiple Buckets with Different Roles
Multiple roles can be passed as separate arguments. The following command will attempt to scan every bucket each role has permissions to list in the S3 API:

```shell
th s3 --role-arn=<iam-role-arn-1> --role-arn=<iam-role-arn-2>
```

## Tools and Systems Supported
TruffleHog supports scanning the following systems and tools: Git, GitHub, GitLab, Filesystem, Docker, AWS S3, Google Cloud Storage (GCS), Postman Workspaces, Jenkins Servers, Elasticsearch, Hugging Face Models, Datasets, Spaces, Cross-Fork Object References, and Deleted Commits.

