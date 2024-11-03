{
  description = "My NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    zjstatus.url = "github:dj95/zjstatus";
  };

  outputs = { nixpkgs, home-manager, plasma-manager, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          ./hosts/lenovo-legion-15ach6h/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.sali = import ./home-manager/home.nix;
          }
        ];
      };
    };
  };
}
