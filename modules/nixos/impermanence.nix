{
  config,
  lib,
  ...
}: let
  cfg = config.components.impermanence;
in {
  options.components.impermanence = {
    enable = lib.mkEnableOption "Whether to enable impermanence module.";
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.systemd = {
      enable = true;

      services.rollback = {
        description = "Rollback Btrfs root subvolume to a pristine state";
        wantedBy = ["initrd.target"];

        # 1. systemd-cryptsetup@enc.service:
        #    Ensures the encrypted device is unlocked and available as /dev/mapper/enc.
        # 2. systemd-hibernate-resume.service:
        #    Crucial to avoid a race condition. This service probes the device for
        #    hibernation images. We must wait for it to finish and release the
        #    device lock (EBUSY) before we can mount it for the rollback.
        after = ["systemd-cryptsetup@enc.service" "systemd-hibernate-resume.service"];

        # 1. create-needed-for-boot-dirs.service:
        #    NixOS creates directories for 'neededForBoot' filesystems here. We
        #    must finish our rollback first, otherwise we might delete
        #    directories this service just created.
        # 2. local-fs-pre.target:
        #    The standard systemd target that must be reached before any local
        #    filesystems are mounted.
        # 3. sysroot.mount:
        #    The actual mounting of the (newly restored) root subvolume to /sysroot.
        #    Our pristine state must be ready before this happens.
        before = ["create-needed-for-boot-dirs.service" "local-fs-pre.target" "sysroot.mount"];

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

    fileSystems = {
      "/persist".neededForBoot = true;
      "/var/log".neededForBoot = true;
    };

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
        "/var/lib/sops-nix"
        "/var/lib/systemd"

        "/etc/NetworkManager/system-connections"
        "/var/lib/NetworkManager"
        "/var/lib/bluetooth"
        "/var/lib/chrony"
        "/var/lib/cups"
        "/var/lib/upower"
        "/var/lib/libvirt"
        "/var/cache/libvirt"

        "/var/lib/plasmalogin/wallpapers"
        "/var/lib/AccountsService/icons"
      ];
      files = [
        "/etc/machine-id"
        "/etc/plasmalogin.conf"
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
