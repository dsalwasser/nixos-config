# Installation

This installation guide will walk you through the process of setting up NixOS,
going from the [minimal ISO](https://nixos.org/download/#nixos-iso) to a fully
configured system. This guide is written primarily as a reference for myself.

To begin the installation, you have to boot your computer from the install
drive. Then, run `sudo -i` and optionally use `loadkeys <lang>` to switch to
your preferred keyboard layout. Afterwards, select the disk to install NixOS
onto. To list all available devices use `parted -l`. Furthermore, define the
swap size (e.g., twice the size of your RAM).

```shell
DISK=/dev/sda # replace /dev/sda with your disk
SWAP_SIZE=17 # set to the desired amount in GiB plus one!
```

## Set up the File Systems

First, we will need to set up the partitions. To do so, I recommend using
`parted`. Assuming you have a single-disk system, you will want to create 3
partitions EFI, swap, and data.

```shell
parted "$DISK" -- mklabel gpt

parted "$DISK" -- mkpart esp fat32 1MiB 1GiB
parted "$DISK" -- set 1 boot on

parted "$DISK" -- mkpart swap linux-swap 1GiB ${SWAP_SIZE}GiB

parted "$DISK" -- mkpart main ${SWAP_SIZE}GiB 100%
```

### Disk Encryption

We use dm-crypt to transparently encrypt the main partition, which is available
at `/dev/mapper/enc` afterwards.

```shell
cryptsetup --label encrypted-main --verify-passphrase -v luksFormat "$DISK"3
cryptsetup open "$DISK"3 enc
```

### File Systems

Now we'll create file systems on these partitions, and give them disk labels:

```shell
mkfs.vfat -n boot "$DISK"1

mkswap -L swap "$DISK"2
swapon "$DISK"2

mkfs.btrfs -L main /dev/mapper/enc
```

> [!NOTE]
> For the LUKS encrypted partitions, I'd heavily recommend that you back up the
> LUKS headers in case of a partial drive failure, so that you're still able to
> recover your remaining data. To do this, you can use the following command:
>
> ```bash
> cryptsetup luksHeaderBackup /dev/mapper/enc --header-backup-file /mnt/backup/file.img
> ```

### BTRFS Subvolumes

Next we will split our btrfs partition into the following subvolumes:

- root: The subvolume for `/`, which can be cleared on every boot.
- home: The subvolume for `/home`, which should be persisted across reboots and
  get backed up (snapshotting).
- nix: The subvolume for `/nix`, which needs to be persistent, but not worth
  snapshotting, as it's trivial to reconstruct.
- log: The subvolume for `/var/log`, which should be persisted, and optionally
  backed up.
- persist: The subvolume for `/persist`, containing system-wide state, which
  should be persisted and backed up.

> [!TIP]
> If you do not wish to set up impermanence (wiping root partition after every
> boot), you won't need the `persist` subvolume.
>
> It is very easy to add new BTRFS subvolumes later on, or adjust existing ones
> (even removing is usually quite straightforward), so don't be too afraid if
> you don't yet know if the structure you go with will meet your needs.

```shell
mount -t btrfs /dev/mapper/enc /mnt

btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log
```

If you wish to set up impermanence, take an empty readonly snapshot of the root
subvolume, which we'll eventually rollback to on every boot for impermanence.

```shell
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
```

### Mount the Partitions and Subvolumes

Finally, mount the btrfs subvolumes and the boot file system.

> [!NOTE]
> Even though we're specifying the `compress` flag in the mount options of each
> btrfs subvolume, somewhat misleadingly, you can't actually use different
> compression levels for different subvolumes. Btrfs will share the same
> compression level across the whole partition, so it's pointless to attempt to
> set different values here.

```shell
mount -o subvol=root,compress=zstd:3,noatime /dev/mapper/enc /mnt
mount --mkdir -o subvol=home,compress=zstd:3,noatime /dev/mapper/enc /mnt/home
mount --mkdir -o subvol=nix,compress=zstd:3,noatime /dev/mapper/enc /mnt/nix
mount --mkdir -o subvol=log,compress=zstd:3,noatime /dev/mapper/enc /mnt/var/log
mount --mkdir -o subvol=persist,compress=zstd:3,noatime /dev/mapper/enc /mnt/persist

mount --mkdir "$DISK"1 /mnt/boot
```

## Generate the NixOS Configuration

Now let NixOS figure out the default configuration files, which are placed
at `/mnt/etc/nixos/configuration.nix` and
`/mnt/etc/nixos/hardware-configuration.nix`.

```shell
nixos-generate-config --root /mnt
```

### Hardware Configuration

First, set up the hardware configuration file. If you see the root file system
(or any other) declared multiple times, it is safe to remove the duplicate
definitions. Also ensure that `"compress=zstd:3" "noatime"` is added to the
options of all file systems except for `/boot`.

In order to correctly persist `/var/log`, the respective subvolume need to be
mounted early enough in the boot process. To do this, we will want to add
`neededForBoot = true;`. Additionally, if you will be following up with
impermanence, you will also need to add this parameter for our `/persist`
subvolume.

### Main Configuration

Next, set up a relatively minimal configuration file such as the following.

```nix
{ config, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings = {
    # Enable flakes and the new 'nix' command.
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize the nix store.
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  boot.supportedFilesystems = [ "btrfs" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Define your time zone.
  time.timeZone = "Europe/Berlin";
  # Setting RTC time standard to localtime, compatible with Windows in its
  # default configuration.
  time.hardwareClockInLocalTime = true;

  # Define your default locale.
  i18n.defaultLocale = "de_DE.UTF-8";
  # Set the default locale and configure the virtual console keymap from the
  # xserver keyboard settings.
  console.useXkbConfig = true;

  # Define a user account.
  users.users.sali = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Enable the KDE Desktop Environment.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  # This options defines the first version of NixOS you have installed on this
  # particular machine, and is used to maintain compatibility with application
  # data (e.g. databases) created on older NixOS versions.
  system.stateVersion = "24.05";
}
```

Ensure that you correctly specify the version of NixOS you have installed,
i.e., the version that is included in the configuration file generated above,
in `system.stateVersion = "24.05";`.

## Install NixOS

Finally, run the following commands to complete the NixOS installation.

```shell
nixos-install
reboot
```

If all goes well, you’ll be prompted for the passphrase for decryption, then
you’ll see the greeter for the KDE Desktop Environment. Switch to another tty
with `Ctrl+Alt+F1`, login as root, `passwd <user>` to set your password, and
switch back to KDE with `Ctrl+Alt+F7`. Once you’re logged in, fetch this
repository by running the following commands

```shell
nix shell nixpkgs#git # Enter an interactive shell which contains Git
git clone https://github.com/dsalwasser/nixos-config.git
```

and `cd` into that directory. Afterwards, make sure you include the correct
host module in the `flake.nix` file and ensure that you correctly specify the
version of NixOS you have installed in the option `system.stateVersion` of the
`nixos/configuration.nix` file and in the option `home.stateVersion` of the
`home-manager/home.nix` file. Finally, run

```shell
sudo nixos-rebuild switch --flake .#<target>
```
to rebuild your system and to finish the installation. Replace `<target>` with
your desired system target (for example, `lenovo`).
