#!/usr/bin/env sh
# configure git with user info
echo "Running script in $(pwd)"
git config commit.gpgsign true
echo "GPG sign set to true"
git config user.signingkey 76DF323656200BF9
echo "Signing key set"
git config user.name "Will Bosch-Bello" && git config user.email "williamsbosch@gmail.com"
echo "User name and email set"
git config core.sshCommand "ssh -i ~/.ssh/id_rsa_per -o IdentitiesOnly=yes"
echo "SSH command configured"
