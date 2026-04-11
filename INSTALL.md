# Installation Guide

This guide explains how to install NixOS using this flake configuration, from
creating a bootable installer USB to completing the first boot. This guide is
written primarily as a reference for myself.

## Install Drive

To create a install drive, you can use either the official NixOS ISO or the
custom installer image built from this repository.

### Minimal ISO

Download the latest [NixOS Minimal ISO](https://nixos.org/download/#nixos-iso).
After downloading, create a bootable USB flash drive from a Linux terminal:

1. Plug in the USB flash drive.
1. Find the corresponding device using `lsblk` (identify it by size).
1. Unmount all partitions on that USB device (replacing `sdX` with your drive):

```bash
sudo umount /dev/sdX*
```

1. Write the ISO image to the USB drive (replacing `<path-to-image>` and `sdX`):

```bash
sudo dd bs=4M conv=fsync oflag=direct status=progress if=<path-to-image> of=/dev/sdX
```

When `dd` finishes, safely eject the drive and boot from it.

### Installer ISO

This flake also provides a custom installer image, which can be built with:

```bash
nix build .#installer-image
```

After the build completes, the ISO is available at:

```text
result/iso/nixos-<version>-x86_64-linux.iso
```

Burn this image to a USB drive using the same process as in the Minimal ISO
section.

## Installation

To begin the installation, you have to boot your computer from the install
drive. Then, run `sudo -i` and optionally use `loadkeys <lang>` to switch to
your preferred keyboard layout.

### 1. Clone This Repository

Clone the configuration repository and enter it:

```bash
git clone https://github.com/dsalwasser/nixos-config.git
cd nixos-config
```

### 2. Enter The Installation Shell

Start `nix-shell` to download and provide the required installation tools:

```bash
nix-shell
```

### 3. Prepare The Disk

Run `disko` using for partition, format, and mount the disk:

```bash
disko --mode destroy,format,mount hosts/lenovo/disk-configuration.nix
```

Note that this will erase and repartition the target disk. Make sure the
selected disk is the correct one before confirming. Also, choose a strong
password for full disk encryption.

### 4. Provide Secrets Key

Before installing, ensure the secrets key exists at the expected location.
Otherwise, you won't be able to login when the installation is complete.

```bash
mkdir -p /mnt/persist/var/lib/sops-nix
cp /path/to/your/keys.txt /mnt/persist/var/lib/sops-nix/keys.txt
chmod 600 /mnt/persist/var/lib/sops-nix/keys.txt
```

Replace `/path/to/your/keys.txt` with the actual location of your key file.

### 5. Install NixOS

Finally, run the following commands to complete the NixOS installation.

```bash
nixos-install --flake .#lenovo
```

After installation completes, reboot into the new system. If all goes well,
you’ll be prompted for the passphrase for decryption, then you’ll see the
greeter for the KDE desktop environment.

## Post-Installation

### Backing up the Disk Encryption Headers

For the LUKS encrypted partitions, I'd heavily recommend that you back up the
LUKS headers in case of a partial drive failure, so that you're still able to
recover your remaining data. To do this, you can use the following command:

```bash
cryptsetup luksHeaderBackup /dev/mapper/enc --header-backup-file /file.img
```

### Set up FIDO2 Keys for Disk Encryption

To enroll your security key for decryption, boot into your installed system and run:

```bash
systemd-cryptenroll --fido2-device=auto /dev/disk/by-partlabel/luks
```

During enrollment, follow the prompts from your key (touch and PIN, depending
on your key settings).

Verify that the token was added successfully:

```bash
sudo systemd-cryptenroll /dev/disk/by-partlabel/luks
```

### Set up Secure Boot

TODO

### Compile Hardened Kernel

TODO
