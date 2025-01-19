# PAM Configuration for 2FA

This repository contains PAM configuration files for enforcing two-factor authentication (2FA) on different login mechanisms for your Linux system. The configurations ensure that the system requires both a password and a second factor (YubiKey and/or Google Authenticator) for secure logins, while `sudo` is configured to use only the YubiKey.

### File Overview

1. **gdm-password.conf**:
   - Manages the authentication process for **GDM (GNOME Display Manager)** graphical logins.
   - Requires password + YubiKey (or Google Authenticator) for 2FA.

2. **lightdm.conf**:
   - Configures authentication for **LightDM** graphical logins.
   - Uses 2FA with YubiKey and Google Authenticator.

3. **login.conf**:
   - Handles **TTY and console logins** (e.g., `Ctrl + Alt + F3` to access a terminal).
   - Enforces 2FA with YubiKey and Google Authenticator for all console logins.

4. **sddm.conf**:
   - Configures the authentication process for **SDDM (Simple Desktop Display Manager)** graphical logins.
   - Requires YubiKey and/or Google Authenticator for 2FA.

5. **sudo.conf**:
   - Manages authentication for the `sudo` command.
   - Uses **YubiKey** for `sudo` commands with a password fallback. This ensures that elevated privileges require hardware-based authentication.

### Configuration Files Summary

- **@include common-auth**: Includes the default authentication methods.
- **pam_u2f.so**: Enforces YubiKey-based authentication.
- **pam_google_authenticator.so**: Enforces Google Authenticator for TOTP-based authentication.

### How to Apply

To apply these configurations, ensure they are placed in `/etc/pam.d/` on your system, replacing or supplementing the existing configuration files. After applying, reboot your system or restart the display managers to ensure the changes take effect.
