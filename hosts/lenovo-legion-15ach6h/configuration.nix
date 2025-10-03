{ config, pkgs, ... }: {
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  services = {
    # Enable periodic SSD TRIM of mounted partitions in background.
    fstrim.enable = true;

    # Set TLP as the power management tool.
    power-profiles-daemon.enable = true;

    # Load video drivers for Xorg and Wayland.
    xserver.videoDrivers = [ "amdgpu" "nvidia" "modesetting" ];
  };

  specialisation.disable-nvidia-dgpu.configuration = {
    boot.extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
    '';

    services.udev.extraRules = ''
      # Remove NVIDIA USB xHCI Host Controller devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA USB Type-C UCSI devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA Audio devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA VGA/3D controller devices
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
    '';
    boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
  };

  hardware = {
    # Enable all the firmware regardless of license.
    enableAllFirmware = true;

    # Update the CPU microcode for AMD processors.
    cpu.amd.updateMicrocode = true;

    graphics = {
      # Enable OpenGL.
      enable = true;

      # Enabe accelerated video playback.
      extraPackages = [ pkgs.vaapiVdpau ];
    };

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;

      modesetting.enable = true;
      powerManagement.enable = true;

      # Do not use the NVIDIA open source kernel module (not to be confused with
      # the independent third-party "nouveau" open source driver) as it has not
      # good support for sleep and hibernate.
      open = false;

      prime = {
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:6:0:0";

        offload = {
          enable = true;

          # Provides `nvidia-offload` command.
          enableOffloadCmd = true;
        };
      };
    };
  };

  boot = {
    # Use the latest kernel.
    kernelPackages = pkgs.linuxPackages_latest;

    # Enables the amd cpu scaling and hardware framebuffer support, which is
    # required to somewhat consistently resume from suspend-to-ram.
    kernelParams = [ "amd_pstate=active" "nvidia_drm.fbdev=1" ];

    kernelModules = [ "amdgpu" "kvm-amd" "nvidia" ];
    initrd.availableKernelModules = [ "ahci" "nvme" "usbhid" "xhci_pci" ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
