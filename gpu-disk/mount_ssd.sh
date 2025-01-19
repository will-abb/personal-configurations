#!/usr/bin/env bash

# Check if the device is encrypted and can be opened
encrypted_device="/dev/sda1"
mapper_name="sda1_crypt"
mount_point="/mnt/mi_segu_dis"

# Check for existing mapper
if [ -e "/dev/mapper/${mapper_name}" ]; then
  echo "The device is already decrypted and mapped as ${mapper_name}."
else
  # Attempt to open the encrypted device
  echo "Attempting to open the encrypted device ${encrypted_device}..."
  sudo cryptsetup open "${encrypted_device}" "${mapper_name}" && echo "Device decrypted and opened successfully as ${mapper_name}." || { echo "Failed to open encrypted SSD. It may not be encrypted or is in use."; exit 1; }
fi

# Check and create the mount point if it doesn't exist
if [ -d "${mount_point}" ]; then
  echo "Mount point ${mount_point} already exists."
else
  echo "Creating mount point ${mount_point}..."
  sudo mkdir "${mount_point}" && echo "Mount point created successfully." || { echo "Failed to create mount directory ${mount_point}."; exit 1; }
fi

# Mount the device if it's not already mounted
if mount | grep -q "${mount_point}"; then
  echo "The device is already mounted at ${mount_point}."
else
  echo "Mounting device..."
  sudo mount "/dev/mapper/${mapper_name}" "${mount_point}" && echo "Device mounted successfully at ${mount_point}." || { echo "Failed to mount device at ${mount_point}. It may be in use or already mounted elsewhere."; exit 1; }
fi

# Display device mount status and details
if mount | grep -q "${mount_point}"; then
  echo "Final mount status: Device is mounted correctly at ${mount_point}. Here are the details:"
  lsblk -f | grep "${mapper_name}"
  df -h | grep "${mount_point}"
else
  echo "Device is not mounted at ${mount_point}."
fi

# Optional: Uncomment to add permanent auto-mount entries
# echo "${mapper_name} UUID=$(sudo blkid -s UUID -o value ${encrypted_device}) none luks" | sudo tee -a /etc/crypttab
# echo "/dev/mapper/${mapper_name} ${mount_point} ext4 defaults 0 2" | sudo tee -a /etc/fstab
