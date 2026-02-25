{pkgs, ...}: {
  # Enables QEMU guest integration features.
  components.qemu-guest.enable = true;

  boot = {
    # Use the latest Linux kernel.
    kernelPackages = pkgs.linuxPackages_latest;

    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
