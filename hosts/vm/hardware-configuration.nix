{pkgs, ...}: {
  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = ["kvm-amd"];

    initrd = {
      availableKernelModules = [
        "virtio_net"
        "virtio_pci"
        "virtio_mmio"
        "virtio_blk"
        "virtio_scsi"
        "9p"
        "9pnet_virtio"
        "xhci_pci"
        "ohci_pci"
        "ehci_pci"
        "virtio_pci"
        "ahci"
        "usbhid"
        "sr_mod"
        "virtio_blk"
      ];

      kernelModules = [
        "virtio_balloon"
        "virtio_console"
        "virtio_rng"
        "virtio_gpu"
      ];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
