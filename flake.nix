{
  description = "My NixOS and Home Manager configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-index-database, plasma-manager, spicetify, ... }@inputs:
    let
      nixos-system = host-config: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        modules = [
          ./nixos/configuration.nix
          host-config
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.sharedModules = [
              nix-index-database.homeModules.nix-index
              plasma-manager.homeManagerModules.plasma-manager
              spicetify.homeManagerModules.default
            ];
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.sali = import ./home-manager/home.nix;
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        lenovo = nixos-system ./hosts/lenovo-legion-15ach6h/configuration.nix;
        kvm = nixos-system ./hosts/kvm/configuration.nix;
        virtual-box = nixos-system ./hosts/virtual-box/configuration.nix;
      };
    };
}
