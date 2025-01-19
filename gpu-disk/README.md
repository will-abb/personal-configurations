# GPU and Disk Configuration

This folder contains scripts and configurations for managing an encrypted SSD and optimizing NVIDIA GPU performance.

## Files

1. **mount_ssd.sh**
   - A Bash script to mount an encrypted SSD.
   - Handles device decryption, mount point creation, and mounting the device.

2. **nvidiaperformance.desktop**
   - A desktop entry file to automatically execute GPU performance optimization on startup.

3. **nvidiaperformance.sh**
   - A script to optimize NVIDIA GPU settings, including enabling persistence mode and configuring performance options.

## Usage

- **mount_ssd.sh**: Run manually to mount the encrypted SSD when needed.
- **nvidiaperformance.desktop**: Place in the appropriate autostart directory for execution on reboot.
- **nvidiaperformance.sh**: Ensures GPU performance is maximized; already set to run at reboot.
