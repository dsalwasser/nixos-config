{
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [
    "${toString modulesPath}/installer/cd-dvd/iso-image.nix"
  ];

  isoImage.compressImage = false;
  isoImage.squashfsCompression = "zstd -Xcompression-level 3";
}
