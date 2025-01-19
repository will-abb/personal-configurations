# Custom Keyboard Shortcuts Setup

This guide outlines the process for setting up custom keyboard shortcuts for various applications and scripts on GNOME using the `create_shortcuts.sh` script.

## Adding a New Shortcut

To add a new shortcut, you'll need to create a corresponding shell script and then modify the `create_shortcuts.sh` script to include it.  Alternatively, if the shortcut doesn't require a script, you can just modify it and add it to the create shortcut file.

### Example: Creating a Google Shortcut

1. Create a new file named `google_shortcut.sh` in the shortcuts directory:

   ```bash
   nano ~/repositories/bitbucket/williseed1/configs/initial_setup/shortcuts/google_shortcut.sh
   ```

2. Add the following content to `google_shortcut.sh`:

   ```bash
   #!/bin/bash
   google-chrome --new-window https://www.google.com
   ```

3. Make the script executable:

   ```bash
   chmod +x ~/repositories/bitbucket/williseed1/configs/initial_setup/shortcuts/google_shortcut.sh
   ```

### Modifying `create_shortcuts.sh` to Include the New Shortcut

Open the `create_shortcuts.sh` script and append the new shortcut to the `set_custom_shortcuts` function call:

```bash
set_custom_shortcuts \
    "Google:~/repositories/bitbucket/williseed1/configs/initial_setup/shortcuts/google_shortcut.sh:<Super>g"
```
**Make sure that you have the '\' before and make sure there's no space after the backslash or it will break.**

## Running `create_shortcuts.sh`
**You will need to run the script with all of the shortcuts when you make a change. Don't just comment out the existing ones. It needs to be rerun or you will only have whatever you have uncommented.**
To apply the shortcuts, execute the `create_shortcuts.sh` script:

```bash
bash ~/repositories/bitbucket/williseed1/configs/initial_setup/shortcuts/create_shortcuts.sh
```
