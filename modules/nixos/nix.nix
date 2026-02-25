{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.components.nix;
in {
  options.components.nix = {
    enable = lib.mkEnableOption "Whether to use modern Nix settings.";
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
        # Automatically detect files in the store that have identical contents,
        # and replaces them with hard links to a single copy.
        auto-optimise-store = true;

        # Enable Nix flakes and the new 'nix' command.
        experimental-features = "nix-command flakes";

        # Increase the parallel TCP connections used to fetch files.
        http-connections = 128;

        # Increase the maximum number of substitution jobs that Nix will try to
        # run in parallel.
        max-substitution-jobs = 128;

        # Increase the maximum number of jobs that Nix will try to build
        # locally in parallel.
        max-jobs = "auto";

        # Workaround for https://github.com/NixOS/nix/issues/9574.
        nix-path = config.nix.nixPath;

        # Disable warnings that the Git tree is dirty.
        warn-dirty = false;
      };
    };
  };
}
