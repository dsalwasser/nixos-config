{
  config,
  lib,
  ...
}: {
  services = {
    # Enable periodic SSD TRIM of mounted partitions in background.
    fstrim.enable = true;

    # Load video drivers for Wayland.
    xserver.videoDrivers = ["amdgpu" "nvidia"];
  };

  hardware = {
    # Update the CPU microcode for the processor.
    cpu.amd.updateMicrocode = true;

    # Enable all the firmware that is redistributable.
    enableRedistributableFirmware = true;

    # Enable OpenGL and accelerated video playback.
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      # Install the latest Nvidia drivers.
      package = config.boot.kernelPackages.nvidiaPackages.beta;

      # Use the open source Nvidia kernel module.
      open = true;

      # Enable Nvidia DRM kernel modesetting so Wayland/KWin can initialize the
      # GPU correctly (needed for PRIME/offload setups and to reduce stutter).
      modesetting.enable = true;

      # Enable power management through systemd.
      powerManagement = {
        enable = true;
        finegrained = true;
      };

      # Configure Nvidia Optimus PRIME.
      prime = {
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:6:0:0";

        # Offload mode puts your Nvidia GPU to sleep and lets the Intel GPU
        # handle all tasks, except if you call the Nvidia GPU specifically by
        # "offloading" an application to it.
        offload = {
          enable = true;

          # Provides `nvidia-offload` command.
          enableOffloadCmd = true;
        };
      };
    };
  };

  # Make sure KWin uses the Nvidia graphics for rendering. This is currently
  # necessary to avoid performance issues and occasional stutters.
  environment.variables.KWIN_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1";

  # Add a specialization that disables the Nvidia GPU.
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

    boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidia_drm" "nvidia_modeset"];

    hardware.nvidia = {
      powerManagement = {
        enable = lib.mkForce false;
        finegrained = lib.mkForce false;
      };

      prime.offload = {
        enable = lib.mkForce false;
        enableOffloadCmd = lib.mkForce false;
      };
    };
  };

  boot = {
    # Enables AMD CPU scaling and Nvidia hardware framebuffer support.
    kernelParams = ["amd_pstate=active" "nvidia_drm.fbdev=1"];

    kernelModules = ["amdgpu" "nvidia" "kvm-amd"];

    initrd = {
      systemd.enable = true;

      kernelModules = [
        # Driver module for graphic card controller.
        "amdgpu"
        "nvidia"

        # Driver module for the Ethernet and WLAN controller.
        "r8169"
        "rtw88_8822ce"
      ];

      availableKernelModules = [
        # Driver modules for the disk and storage controller.
        "ahci"
        "nvme"

        # Driver module for the USB controller.
        "usbhid"
        "xhci_pci"
      ];
    };

    # Use the systemd-boot EFI boot loader.
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 0;
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
