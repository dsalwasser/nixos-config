{
  boot.initrd.luks.devices."enc".device = "/dev/disk/by-label/encrypted-main";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/main";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd:3" "noatime"];
    };

    "/home" = {
      device = "/dev/disk/by-label/main";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd:3" "noatime"];
    };

    "/nix" = {
      device = "/dev/disk/by-label/main";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd:3" "noatime"];
    };

    "/var/log" = {
      device = "/dev/disk/by-label/main";
      fsType = "btrfs";
      options = ["subvol=log" "compress=zstd:3" "noatime"];
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [{device = "/dev/disk/by-label/swap";}];
}
