#!/bin/bash
# Use the script as a wrapper So that it exports the correct path and Sources the correct virtual environment you just pass the script with arguments: ansible_collection_export_wrapper.sh --exclude=/test-directory --rules=E101

# 1. Activate the dedicated virtual environment
source ~/virtual_environments/ansible-lint/bin/activate

# 2. Set ANSIBLE_COLLECTIONS_PATH if necessary
export ANSIBLE_COLLECTIONS_PATH="~/virtual_environments/ansible/lib/python3.10/site-packages/ansible_collections"

# 3. Execute ansible-lint with all passed arguments
ansible-lint "$@"
