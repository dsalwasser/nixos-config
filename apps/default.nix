pkgs: {
  nix-hash = pkgs.callPackage ./nix-hash.nix {};
  qemu-boot = pkgs.callPackage ./qemu-boot.nix {};
}
