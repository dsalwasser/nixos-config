{inputs, ...}: {
  imports = [
    inputs.self.nixosProfiles.installer
    ./hardware-configuration.nix
    ./image-configuration.nix
  ];
}
