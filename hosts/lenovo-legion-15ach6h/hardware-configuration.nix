{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  # Enable iOS backup and filesystem support.
  services.usbmuxd.enable = true;
  environment.systemPackages = [pkgs.libimobiledevice];

  services = {
    # Set Power Profiles Deamon as the power management tool.
    power-profiles-daemon.enable = true;

    # Enable periodic SSD TRIM of mounted partitions in background.
    fstrim.enable = true;

    # Load video drivers for Xorg and Wayland.
    xserver.videoDrivers = ["amdgpu" "nvidia" "modesetting"];
  };

  # Configure eno1 (wired) and wlp4s0 (wireless) to obtain IP addresses via DHCP.
  networking.interfaces = {
    eno1.useDHCP = true;
    wlp4s0.useDHCP = true;
  };

  hardware = {
    # Enable Bluetooth functionality.
    bluetooth.enable = true;

    # Update the CPU microcode for AMD processors.
    cpu.amd.updateMicrocode = true;

    # Enable all the firmware that is redistributable.
    enableRedistributableFirmware = true;

    # Enable OpenGL and accelerated video playback.
    graphics = {
      enable = true;
      extraPackages = [pkgs.libva-vdpau-driver pkgs.nvidia-vaapi-driver];
    };

    nvidia = {
      # Install the stable (production) Nvidia drivers.
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      modesetting.enable = true;

      # Use the open source NVIDIA kernel module.
      open = true;

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
  };

  boot = {
    # Use the latest Linux kernel.
    kernelPackages = pkgs.linuxPackages_latest;

    # Enables the AMD CPU scaling and hardware framebuffer support, which is
    # required to somewhat consistently resume from suspend-to-ram.
    kernelParams = ["amd_pstate=active" "nvidia_drm.fbdev=1"];

    kernelModules = ["amdgpu" "kvm-amd" "nvidia"];

    initrd = {
      systemd.enable = true;
      kernelModules = ["amdgpu"];
      availableKernelModules = ["ahci" "nvme" "usbhid" "xhci_pci"];
    };

    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
