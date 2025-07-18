{ ... }: {
  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;

    xserver.videoDrivers = [ "qxl" ];
  };

  boot = {
    kernelModules = [ "kvm-amd" ];
    initrd.availableKernelModules = [ "ahci" "virtio_pci" "xhci_pci" "sr_mod" "virtio_blk" ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
