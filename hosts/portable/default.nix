{inputs, ...}: {
  imports = [
    inputs.self.nixosProfiles.portable
    ./hardware-configuration.nix
    ./image-configuration.nix
  ];
}
