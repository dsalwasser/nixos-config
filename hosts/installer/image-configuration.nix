{modulesPath, ...}: {
  imports = [
    "${toString modulesPath}/installer/cd-dvd/iso-image.nix"
  ];

  isoImage = {
    makeEfiBootable = true;
    makeUsbBootable = true;
    squashfsCompression = "zstd -Xcompression-level 3";
  };

  # Add Memtest86+ to the CD.
  boot.loader.grub.memtest86.enable = true;
}
