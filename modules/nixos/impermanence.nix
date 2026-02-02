{
  config,
  lib,
  ...
}: let
  cfg = config.components.impermanence;
in {
  options.components.impermanence = {
    enable = lib.mkEnableOption "Enable impermanence.";
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.systemd = {
      enable = true;

      services.rollback = {
        description = "Rollback Btrfs root subvolume to a pristine state";
        wantedBy = ["initrd.target"];

        # We want to make sure the rollback is done after the LUKS process.
        after = ["systemd-cryptsetup@enc.service"];

        # We want to rollback before mounting the system root during the early
        # boot process
        before = ["sysroot.mount"];

        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          # We first mount the Btrfs root to /mnt-btrfs-root so we can
          # manipulate Btrfs subvolumes.
          mkdir -p /mnt-btrfs-root
          mount -t btrfs -o subvol=/ /dev/mapper/enc /mnt-btrfs-root

          # While we're tempted to just delete /root and create a new snapshot
          # from /root-blank, /root is already populated at this point with a
          # number of subvolumes, which makes `btrfs subvolume delete` fail.
          # So, we remove them first.
          #
          # /root contains the subvolumes:
          # - /root/var/lib/portables
          # - /root/var/lib/machines
          #
          btrfs subvolume list -o /mnt-btrfs-root/root |
            cut -f9 -d' ' |
            while read subvolume; do
              echo "deleting /$subvolume subvolume..."
              btrfs subvolume delete "/mnt-btrfs-root/$subvolume"
            done &&
            echo "deleting /root subvolume..." &&
            btrfs subvolume delete /mnt-btrfs-root/root

          echo "restoring blank /root subvolume..."
          btrfs subvolume snapshot /mnt-btrfs-root/root-blank /mnt-btrfs-root/root

          # Once we're done rolling back to a blank snapshot, we can unmount
          # /mnt-btrfs-root and continue on the boot process.
          umount /mnt-btrfs-root
        '';
      };
    };

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/etc/NetworkManager/system-connections"
        "/var/cache/libvirt"
        "/var/db/sudo/"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/sbctl"
        "/var/lib/systemd"
        "/var/lib/NetworkManager"
        "/var/lib/libvirt"
      ];
      files = [
        "/etc/machine-id"
      ];
    };

    # Required for Impermanence to allow non-root users to access bind-mounted
    # persistent files.
    programs.fuse.userAllowOther = true;

    # Impermanence rollback results in sudo lectures after each reboot, which
    # is why we disable it.
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';
  };
}
