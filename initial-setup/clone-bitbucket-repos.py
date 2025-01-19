from __future__ import annotations

import argparse
import logging
import os
import subprocess
import sys

from atlassian.bitbucket import Cloud
from requests.exceptions import HTTPError

# export BITBUCKET_WORKSPACE_TOKEN=token
# python clone-bitbucket-repos.py --workspace workspace --destination /home/user/repositories/all-repos/


def clone_repository(repo_url, destination):
    if os.path.exists(destination) and os.path.isdir(destination):
        if os.path.exists(os.path.join(destination, ".git")):
            logging.info(f"Repository already cloned at {destination}, skipping.")
            return
        else:
            logging.warning(
                f"Directory {destination} exists but is not a Git repository. Skipping."
            )
            return
    try:
        subprocess.run(["git", "clone", repo_url, destination], check=True)
        logging.info(f"Successfully cloned {repo_url} to {destination}")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to clone {repo_url}: {e}")


def main():
    parser = argparse.ArgumentParser(
        description="Clone all repositories from a Bitbucket workspace."
    )
    parser.add_argument(
        "--workspace",
        "-w",
        required=True,
        help="Bitbucket workspace to pull repositories from.",
    )
    parser.add_argument(
        "--destination",
        "-d",
        required=True,
        help="Local directory to clone repositories into.",
    )
    args = parser.parse_args()

    if os.environ.get("DEBUG"):
        level = logging.DEBUG
    else:
        level = logging.INFO

    logging.basicConfig(level=level)

    # BITBUCKET_WORKSPACE_TOKEN should be set as an environment variable
    token = os.getenv("BITBUCKET_WORKSPACE_TOKEN")
    if not token:
        logging.error("BITBUCKET_WORKSPACE_TOKEN environment variable is not set.")
        sys.exit(1)

    # Initialize the Bitbucket Cloud API client
    cloud = Cloud(token=token, backoff_and_retry=True)
    workspace_name = args.workspace

    if not os.path.exists(args.destination):
        os.makedirs(args.destination)

    logging.info(f"Fetching repositories for workspace: {workspace_name}")

    try:
        # Get the workspace object
        workspace = cloud.workspaces.get(workspace_name)

        # List all repositories in the workspace
        repositories = list(workspace.repositories.each())

        logging.info(
            f"Found {len(repositories)} repositories in the workspace '{workspace_name}'."
        )

        # Inspect the structure of the first repository object
        if repositories:
            logging.debug(f"First repository object structure: {dir(repositories[0])}")

        # Clone each repository
        for repo in repositories:
            repo_name = repo.slug
            repo_url = (
                f"git@bitbucket.org:{workspace_name}/{repo_name}.git"  # noqa: E231
            )
            destination = os.path.join(args.destination, repo_name)
            clone_repository(repo_url, destination)

    except HTTPError as http_err:
        logging.error(
            f"HTTP error occurred: {http_err.response.status_code} - {http_err.response.text}"
        )
    except Exception as err:
        logging.error(f"An error occurred: {err}")
        sys.exit(1)


if __name__ == "__main__":
    main()
