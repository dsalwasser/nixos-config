{
  lib,
  config,
  modulesPath,
  ...
}: let
  inherit (config.image.repart.verityStore) partitionIds;
in {
  imports = [
    "${toString modulesPath}/image/repart.nix"
    "${toString modulesPath}/profiles/image-based-appliance.nix"
  ];

  system = {
    image = {
      id = "nixos-appliance";
      version = "1";
    };

    # Do not create ´/usr/bin/env´ as this would require some extra work on
    # read-only ´/usr´ and it is not a strict necessity.
    activationScripts.usrbinenv = lib.mkForce "";
  };

  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = ["mode=0755"];
    };
    "/nix/store" = {
      device = "/usr/nix/store";
      options = ["bind"];
    };
    "/home" = {
      device = "/dev/mapper/home";
      fsType = "btrfs";
      options = ["compress=zstd:3" "noatime"];
    };
  };

  # Ensure the user's home directory exists with correct ownership on first
  # boot.
  systemd.tmpfiles.rules = [
    # Type Path           Mode  User   Group  Age   Argument
    "d    /home/sali      0700  1000   100     -     -"
  ];

  image.repart = {
    name = "portable-nixos-image";

    # Build this image with a dm-verity protected nix store.
    verityStore = {
      enable = true;
      ukiPath = "/EFI/BOOT/BOOT${lib.toUpper config.nixpkgs.hostPlatform.efiArch}.EFI";
    };

    # Configure the physical disk layout, including the ESP, the dm-verity hash
    # partition, the store partition, and the encrypted home.
    partitions = {
      ${partitionIds.esp} = {
        # Note that the UKI is injected into this partition by the verityStore
        # module and thus omitted in the config.
        repartConfig = {
          Type = "esp";
          SizeMinBytes =
            if config.nixpkgs.hostPlatform.isx86_64
            then "64M"
            else "96M";
          Format = "vfat";
        };
      };
      ${partitionIds.store-verity}.repartConfig = {
        Minimize = "best";
      };
      ${partitionIds.store}.repartConfig = {
        Minimize = "best";
      };
      "home".repartConfig = {
        Type = "home";
        Label = "home";
        SizeMinBytes = "512M";
        SizeMaxBytes = "2G";
        Format = "btrfs";
        Encrypt = "key-file";
        # KeyFile = "...";
        Integrity = "inline";
        Compression = "zstd";
        CompressionLevel = 3;
      };
    };
  };

  boot = {
    # Unlock the encrypted home partition at startup and add support for
    # decryption via FIDO2 tokens.
    initrd.luks.devices."home" = {
      device = "/dev/disk/by-partlabel/home";
      crypttabExtraOpts = ["fido2-device=auto"];
    };

    # Disable the default boot loader since we boot the UKI directly.
    loader.grub.enable = false;
  };
}
