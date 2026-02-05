{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  NIX_CONFIG = ''
    extra-experimental-features = nix-command flakes
    http-connections = 128
    max-substitution-jobs = 128
    max-jobs = auto
  '';

  packages = with pkgs; [
    age
    disko
    git
    helix
    nixos-facter
    sops
  ];
}
