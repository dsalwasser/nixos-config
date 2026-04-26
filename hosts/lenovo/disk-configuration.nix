{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:02:00.0-nvme-1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              label = "boot";
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            luks = {
              priority = 2;
              label = "luks";
              size = "100%";
              content = {
                type = "luks";
                name = "enc";
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                  crypttabExtraOpts = ["fido2-device=auto" "x-initrd.attach"];
                };
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "nixos" "-f"];
                  # We create an empty snapshot on creation that serves as a
                  # baseline for the impermanence module, allowing it to reset
                  # the filesystem contents on each reboot.
                  postCreateHook = ''
                    mount -t btrfs /dev/mapper/enc /mnt
                    btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
                    umount /mnt
                  '';
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = ["subvol=root" "compress=zstd" "noatime"];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = ["subvol=home" "compress=zstd" "noatime"];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                    };
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["subvol=log" "compress=zstd" "noatime"];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = ["subvol=persist" "compress=zstd" "noatime"];
                    };
                    "/swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "32G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  boot = {
    kernelParams = [
      # To make Hibernation work, we need to specify a resume offset obtained
      # via the following command:
      # - btrfs inspect-internal map-swapfile -r /swap/swapfile
      "hibernate.image_size=0"
      "resume=/dev/mapper/enc"
      "resume_offset=533760"

      # Enable zswap and use lz4 as the compression algorithm.
      "zswap.enabled=1"
      "zswap.compressor=lz4"
      "zswap.shrinker_enabled=1"
    ];

    # Make sure lz4 is available as otherwise zswap falls back to zstd.
    initrd.kernelModules = ["lz4"];
  };
}
