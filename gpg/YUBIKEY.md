# Setting up Yubikey with gpg
1. Install Software
https://support.yubico.com/hc/en-us/articles/360016649039-Installing-Yubico-Software-on-Linux
2. Reset openpgpg
https://support.yubico.com/hc/en-us/articles/360013761339-Resetting-the-OpenPGP-Application-on-the-YubiKey
3. setting up https://support.yubico.com/hc/en-us/articles/360013790259-Using-Your-YubiKey-with-OpenPGP
4. If you have issues with gpg --card-edit or status for yubikey use `sudo systemctl restart pcscd`
