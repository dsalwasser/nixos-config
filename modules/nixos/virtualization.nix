{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.components.virtualization;
in {
  options.components.virtualization = {
    enable = lib.mkEnableOption "Whether to enable the virtualization subsystem.";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      # Enable common container config files in /etc/containers.
      containers.enable = true;

      # Enable Podman.
      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;
        dockerSocket.enable = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };

      # Enable libvirt, a tool for managing platform virtualization.
      libvirtd = {
        enable = true;

        qemu = {
          # Add VirtioFS to mount shared filesystems between host and guest.
          vhostUserPackages = [pkgs.virtiofsd];

          # Enable TPM emulation.
          swtpm.enable = true;
        };
      };

      # Enable the SPICE USB redirection helper, which allows unprivileged
      # users to pass USB devices connected to this machine to libvirt VMs,
      # both local and remote. Note that this allows users arbitrary access to
      # USB devices.
      spiceUSBRedirection.enable = true;
    };

    # Register ARM64 binary format and allow the use of it inside containers.
    boot.binfmt = {
      emulatedSystems = ["aarch64-linux"];
      preferStaticEmulators = true;
    };
  };
}
