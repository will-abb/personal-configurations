# Initial Windows Setup

## Known Issues
1. You open a new shell you must run as admin the policy must be set for user `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` or just for current shell `Set-ExecutionPolicy Bypass -Scope Process -Force` if you have problems.
2. If you have problems with script, espcially with ssh key creation script then don't use ISE, use regular powershell and make sure ssh service is enabled. Do not use a password with your SSH key in windows, or you will have major issues. I've already tried everything to make this work and can't.
3. For GIT to work with ssh key and rememeber your password you must set up user an environmental variable permanently: `GIT_SSH=C:\Windows\System32\OpenSSH\ssh.exe`
4. vim clipboard not copying issues: File > Preferences > Settings > In the settings search bar, search for vim.useSystemClipboard. Enable the Vim: Use `System Clipboard` option. Vim must be enabled beforehand

## Initial Setup for WSL and windows
1. Start using keyboardio setup right away. It should have windows dictation and switching to different applications as keys.
2. Use windows zooming display only up to 125%, Otherwise, the gui will be too big. You can always just change the font.
3. Install Firefox, then add bitwarden extension, then use this new setup to log into firefox account. Finally log into bitbucket to have the scripts available.
4. Install vscode, but not from store, log into it with Github williamsbosch@gmail.com to sync settings. Got to File > Auto Save to enable it.
5. **initial-setup.ps1**: run script then restart shell.
6. **setup-ansible.ps1**: setup ansible. Rebooting might be needed or restarting shells and/or programs.
7. **setup-wsl-pre-restart.ps1**: run script to enable wsl, then restart.
8. **setup-wsl-post-restart.ps1**: run script to install ubuntu.
9. Launch app ubuntu 22, not wsl app. Provide simple username and password.
10. **download-configure-repositories.ps1**: download repos with branches
11. install powershell7: `winget install --id Microsoft.PowerShell --source winget`
12. **highlight-window2.ahk**: Use this script to highlight windows. It must be ran at startup. There's also a version for ahk1. You can change the color accordingly of the highlight. You will have to not maximize completely all windows.

### Optional Scripts:
**ssh.ps1** sets up ssh and key. Only use if you have issues because other scripts take care of this.
**setup-ansible-old-script.ps1**: depracated, only run if ansible setup did not succeed. Rebooting might be needed.
**install-python310.ps1** Set out a virtual environment for python. 3.10.

### Setting Things Up in Windows instead of WSL
1. **install-chrysalis**.ps1: setups up chrysalis
2. **setup-env-vars**: sets up needed variables especially for emacs.
3. **choco-install.ps1**: sets up all software possible via chocolate.
4. For copyq you have to have two commands. Start the server: `copyq`, get the client `copyq show`. Use wsl it's way faster.
4. **install-doom.ps1**: installs doom emacs and dependencies via choco.
5. Run `git clone git@bitbucket.org:williseed1/configs.git`, `git checkout windows-org-config`, then `doom sync`.
6. Run both doom functions: `all-the-icons-dired-mode` and  `nerd-icons-install-fonts`, specify a directory. Then go to that directory and click on each file that was downloaded. Select install and it will install that font.
7. create-shortcuts.md: Follow this to create shortcuts.
8. install shell-gpt: follow instructions below.
9. **sops-install.ps1**: Install sops.

## Setting things up in WSL
### Follow regular ubuntu README.md:
You should be able to run all these in your new wsl. Look at regular inital-setup readme for missing updated info.
- create ssh key without password (unless you figure out saving key password issue)
- remove apt/snap packages beforehand
1. **install_apt_packages.yaml**: Installs a range of software packages via APT.
2. **install_snap_packages.yaml**: Installs various software packages via Snap.
3. **install_ripgrep.yaml**: Installs ripgrep, a high-performance search tool that respects your gitignore.
5. **doom_emacs.yaml**: Sets up Doom Emacs. Switch to latest branch. To avoid error my/magit-clone these: `git clone https://github.com/snowiow/aws.el.git`, run `install font icons` or the nerd version.
7. **oh_my_zsh.yaml**: Sets up Oh My Zsh. Switch to latest branch.
8. **shell_configs.yaml**: Sets up zsh and terminator configs.
14. **sops.yaml**: Installs SOPS (Secrets OPerationS).
15. **ssm_session_manager_plugin.yaml**: Installs the AWS Session Manager Plugin for secure, auditable instance management.
16. **terraform.yaml**: Installs Terraform, an open-source infrastructure as code software tool.
17. **terraform_tools.yaml**: Installs Terraform tools.
20. **terraform_docs.yaml**: Installs Terraform Docs for generating documentation from Terraform modules.
26. **scripts_venv.yaml**: Scripts virtualenv.
27. **docker_install.yaml**: Installs Docker. Run `sudo usermod -aG docker $USER` then logout and you will not have to use sudo.
30. **go_packages_install.yaml**: Automates the setup of Go language packages for development environments.
31. **install_secret_tools.yaml**: Sets up tools for secure secret management, including Vault and GPG.
32. **install_node_npm.yaml**:  install node.js 21 this is so that you can use some LSP servers.
33. **install_gradle.yaml**: install gradle, then add to path in zsh configs.
34. **.ssh/config**: repos-git/ssh.conf, copy this file into your .ssh config file, this is to help with code commit and tramp ssm
36. Follow aws-vault install instructions below
### Shell GPT
- sgpt: pip3 `install shell-gpt`: do globally to be avaiable everywhere.
- you api key is in bitwarden, run `sx '` to do initial setup.  Once the setup is run, you're able to edit this if needed, but you probably won't need to `~/.config/shell_gpt/.sgptrc`
### Update file locate db
run after you're done with everything
``` shell
sudo updatedb
```
### aws vault
Look for newest version on the repo then:
sudo curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/download/v7.2.0/aws-vault-linux-amd64
sudo chmod 755 /usr/local/bin/aws-vault
just run doom emacs aws command "AWS Mode", it will call sso and do everything for you: have  your password ready for your vault
