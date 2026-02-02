{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "";
      inputs.home-manager.follows = "";
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
  };

  outputs = {nixpkgs, ...} @ inputs: let
    # Supported systems for development shells and exported packages. We
    # include every system here. However, it likely happens that certain
    # packages don't build for certain systems.
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    # Helper function to generate the typical per-system flake attributes.
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # Helper function to build a NixOS system given a host-specific config.
    makeNixosSystem = hostConfig:
      nixpkgs.lib.nixosSystem {
        # `specialArgs` are additional arguments passed to a NixOS module
        # function. This should only include the flake inputs.
        specialArgs = {inherit inputs;};

        # We provide a single host-specific configuration file as the entry
        # point. That file imports the rest of the host's configuration,
        # keeping the NixOS system configuration and the flake definition
        # separated.
        modules = [hostConfig];
      };
  in {
    # Packages exported by this flake.
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Formatter used by this flake, accessible through 'nix fmt'.
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # NixOS modules exported by this flake.
    nixosModules = import ./modules/nixos;

    # Home Manager modules exported by this flake.
    homeManagerModules = import ./modules/home-manager;

    # Custom packages and modifications, exported as overlays by this flake.
    overlays = import ./overlays {inherit inputs;};

    # NixOS configurations exported by this flake.
    nixosConfigurations = {
      lenovo = makeNixosSystem ./hosts/lenovo-legion-15ach6h;
      vm = makeNixosSystem ./hosts/vm;
    };
  };
}
