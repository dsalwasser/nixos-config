{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.components.home-manager;
in {
  options.components.home-manager = {
    enable = lib.mkEnableOption "Enable Home Manager.";

    users = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = {};
      description = "Attribute set of usernames mapping to their config files.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      extraSpecialArgs = {inherit inputs;};

      sharedModules = [
        inputs.nix-index-database.homeModules.nix-index
        inputs.plasma-manager.homeModules.plasma-manager
        inputs.spicetify.homeManagerModules.default
        inputs.self.homeManagerModules.combined
      ];

      useGlobalPkgs = true;
      useUserPackages = true;

      # users.sali = import ../../hosts/vm/home-configuration.nix;

      users =
        lib.mapAttrs (name: path: {
          imports = [path];

          home = {
            username = name;
            homeDirectory = "/home/${name}";
          };

          # Let Home Manager manage itself.
          programs.home-manager.enable = true;

          # Nicely reload system units when changing configs.
          systemd.user.startServices = "sd-switch";
        })
        cfg.users;
    };
  };
}
