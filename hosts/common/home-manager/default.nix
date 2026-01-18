{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};

    sharedModules = [
      inputs.nix-index-database.homeModules.nix-index
      inputs.plasma-manager.homeModules.plasma-manager
      inputs.spicetify.homeManagerModules.default
    ];

    useGlobalPkgs = false;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.sali = import ./configuration.nix;
  };
}
