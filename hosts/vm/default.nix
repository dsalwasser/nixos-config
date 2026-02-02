{inputs, ...}: {
  imports = [
    ./configuration.nix
    ./disk-configuration.nix
    ./hardware-configuration.nix
    ./nix-configuration.nix

    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
  ];
}
