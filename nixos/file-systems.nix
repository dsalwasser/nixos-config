# This is the configuration file for the file systems, which should have been
# set up according to the installation documentation.

{ ... }: {
  boot.initrd.luks.devices."enc".device = "/dev/disk/by-label/encrypted-main";

  fileSystems."/" = {
    device = "/dev/disk/by-label/main";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd:3" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/main";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd:3" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/main";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd:3" "noatime" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-label/main";
    fsType = "btrfs";
    options = [ "subvol=log" "compress=zstd:3" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];
}
