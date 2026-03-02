{modulesPath, ...}: {
  imports = [
    "${toString modulesPath}/installer/cd-dvd/iso-image.nix"
  ];

  isoImage = {
    makeEfiBootable = true;
    makeUsbBootable = true;
    squashfsCompression = "zstd -Xcompression-level 3";
  };
}
