{
  config,
  lib,
  ...
}: let
  cfg = config.components.qemu-guest;
in {
  options.components.qemu-guest = {
    enable = lib.mkEnableOption "Whether to enable the QEMU guest subsystem.";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = ["virtio"];
    hardware.graphics.enable = true;

    services = {
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
    };

    boot.initrd = {
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
  };
}
