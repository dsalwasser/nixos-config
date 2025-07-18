#!/usr/bin/env bash
# NixOS installation script

# Exit immediately if any command fails
set -e

# Ask user for disk and swap size
read -ep "Enter the directory where you want to store this configuration: " CONFIG_DIR
read -ep "Enter the disk to install NixOS (e.g., /dev/sda): " DISK
read -ep "Enter the swap size in GiB: " SWAP_SIZE

# Ask the user to enter the passphrase and to re-enter the passphrase to verify
read -ep "Enter the passphrase for LUKS encryption: " -s PASSPHRASE
read -ep "Re-enter the passphrase to verify: " -s PASSPHRASE_CONFIRM

# Check if both passphrases match
if [[ "$PASSPHRASE" != "$PASSPHRASE_CONFIRM" ]]; then
    echo "Error: Passphrases do not match. Please try again."
    exit 1
fi

# Confirm user input
echo "Installing NixOS on $DISK with $SWAP_SIZE GiB swap."
read -rp "Press Enter to continue or Ctrl+C to abort."

# Partitioning
echo "Partitioning $DISK..."
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart esp fat32 1MiB 1GiB
parted "$DISK" -- set 1 boot on
parted "$DISK" -- mkpart swap linux-swap 1GiB "$((SWAP_SIZE + 1))"GiB
parted "$DISK" -- mkpart main "$((SWAP_SIZE + 1))"GiB 100%

# Encrypting main partition
echo "Encrypting main partition..."
echo "$PASSPHRASE" | cryptsetup --label encrypted-main --verify-passphrase -v luksFormat "${DISK}3" --key-file /dev/stdin
echo "$PASSPHRASE" | cryptsetup open "${DISK}3" enc --key-file /dev/stdin

# Formatting partitions
echo "Formatting partitions..."
mkfs.vfat -n boot "${DISK}1"
mkswap -L swap "${DISK}2"
swapon "${DISK}2"
mkfs.btrfs -L main /dev/mapper/enc

# Mount main partition
echo "Mounting main partition..."
mount -t btrfs /dev/mapper/enc /mnt

# Create subvolumes
echo "Creating subvolumes..."
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log

# Mount subvolumes
echo "Mounting subvolumes..."
umount /mnt
mount -o subvol=root,compress=zstd:3,noatime /dev/mapper/enc /mnt
mount --mkdir -o subvol=home,compress=zstd:3,noatime /dev/mapper/enc /mnt/home
mount --mkdir -o subvol=nix,compress=zstd:3,noatime /dev/mapper/enc /mnt/nix
mount --mkdir -o subvol=log,compress=zstd:3,noatime /dev/mapper/enc /mnt/var/log
mount --mkdir -o subvol=persist,compress=zstd:3,noatime /dev/mapper/enc /mnt/persist

# Mount boot partition
echo "Mounting boot partition..."
mount --mkdir "${DISK}1" /mnt/boot

# Copy NixOS config
echo "Copying NixOS configuration..."

if [[ ! -d "$CONFIG_DIR" ]]; then
    echo "Directory does not exist. Creating it now..."
    mkdir -p "$CONFIG_DIR"
fi
cp -r ./ "$CONFIG_DIR"

echo "NixOS installation preparation complete!"
echo "To finalize the installation, run the following command:"
echo "$ sudo nixos-rebuild switch --flake .#kvm"
