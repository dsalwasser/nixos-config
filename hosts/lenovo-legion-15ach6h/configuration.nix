# This is the configuration file for the Lenovo Legion 15ACH6H host.

{ pkgs, ... }: {
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = true;

  #networking.interfaces.docker0.useDHCP = true;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Enable periodic SSD TRIM of mounted partitions in background.
  services.fstrim.enable = true;

  # Set TLP as the power management tool.
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  # Load video drivers for Xorg and Wayland.
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" "modesetting" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    # Enabe accelerated video playback.
    extraPackages = [ pkgs.vaapiVdpau ];
  };

  hardware.nvidia = {
    # Modesetting is needed for most Wayland compositors.
    modesetting.enable = true;

    # Use the NVIDIA open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    open = true;

    # Enable NVIDIA Optimus PRIME in offload mode.
    prime = {
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";

      offload = {
        enable = true;

        # Provides `nvidia-offload` command.
        enableOffloadCmd = true;
      };
    };
  };

  # Enables hardware framebuffer support, which is required to somewhat
  # consistently resume from suspend-to-ram.
  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];

  # Update the CPU microcode for AMD processors.
  hardware.cpu.amd.updateMicrocode = true;

  # Enable all the firmware regardless of license.
  hardware.enableAllFirmware = true;

  boot.initrd.availableKernelModules = [ "ahci" "nvme" "usbhid" "xhci_pci" ];
  boot.kernelModules = [ "amdgpu" "amd_pstate=active" "kvm-amd" "nvidia" ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
