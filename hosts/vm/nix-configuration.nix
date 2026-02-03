{
  config,
  inputs,
  lib,
  ...
}: {
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
    };
  };

  nixpkgs.overlays = [
    inputs.self.overlays.additions
    inputs.self.overlays.modifications
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  # This option defines the first version of NixOS you have installed on this
  # particular machine, and is used to maintain compatibility with application
  # data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for
  # any reason, even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are
  # pulled from, so changing it will NOT upgrade your system - see
  # https://nixos.org/manual/nixos/stable/#sec-upgrading for how to actually do
  # that.
  #
  # This value being lower than the current NixOS release does NOT mean your
  # system is out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes
  # it would make to your configuration, and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "25.11"; # Did you read the comment?
}
