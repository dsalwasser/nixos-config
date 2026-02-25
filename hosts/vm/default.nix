{inputs, ...}: {
  imports = [
    inputs.self.nixosProfiles.portable
    ./disk-configuration.nix
    ./hardware-configuration.nix
  ];
}
