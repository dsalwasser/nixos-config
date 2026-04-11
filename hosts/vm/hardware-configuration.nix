{pkgs, ...}: {
  # Enables QEMU guest integration features.
  components.qemu-guest.enable = true;

  boot = {
    # Use the latest Linux kernel.
    kernelPackages = pkgs.linuxPackages_latest;

    # Enable systemd in initrd.
    initrd.systemd.enable = true;

    # Use the systemd-boot EFI boot loader.
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
