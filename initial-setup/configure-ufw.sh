#!/usr/bin/env bash
cd ~/repositories/bitbucket/williseed1/
git clone git@bitbucket.org:williseed1/security-routines.git
cd ~/repositories/bitbucket/williseed1/security-routines/
git checkout 6-8-2024
ansible-playbook ~/repositories/bitbucket/williseed1/security-routines/system-configurations/configure_ufw.yaml -v
