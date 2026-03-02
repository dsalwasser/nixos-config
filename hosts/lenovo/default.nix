{inputs, ...}: {
  imports = [
    inputs.self.nixosProfiles.sali
    ./disk-configuration.nix
    ./hardware-configuration.nix
  ];
}
