{inputs, ...}: {
  imports = [
    inputs.self.nixosProfiles.portable-live
    ./hardware-configuration.nix
    ./image-configuration.nix
  ];
}
