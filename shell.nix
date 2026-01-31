{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";

  packages = with pkgs; [
    disko
    git
  ];
}
