{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.components.nix;
in {
  options.components.nix = {
    enable = lib.mkEnableOption "Enable the audio subsystem.";
  };

  config = lib.mkIf cfg.enable {
    nix = let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
      # Disable Nix channels
      channel.enable = false;

      # This will add each flake input as a registry to make nix3 commands
      # consistent with this flake.
      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;

      # This will additionally add this flake's inputs to the system's legacy
      # channels. Making legacy nix commands consistent as well.
      nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") flakeInputs;

      settings = {
        # Deduplicate and optimize nix store.
        auto-optimise-store = true;

        # Enable flakes and new 'nix' command.
        experimental-features = "nix-command flakes";

        # Workaround for https://github.com/NixOS/nix/issues/9574.
        nix-path = config.nix.nixPath;

        # Disable warnings that the Git tree is dirty.
        warn-dirty = false;
      };
    };
  };
}
