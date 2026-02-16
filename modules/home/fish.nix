{
  config,
  lib,
  ...
}: let
  cfg = config.components.home.fish;
in {
  options.components.home.fish = {
    enable = lib.mkEnableOption "Whether to enable fish.";
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        # Disable greeting messages.
        set fish_greeting

        # Ensure `SHELL` points to fish so programs detect the correct login shell.
        set -x SHELL (which fish)
      '';
    };

    # Use fish instead of bash as the default shell when using `nix develop`, etc.
    programs.nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };

    # Use a shell prompt renderer for fish.
    programs.oh-my-posh = {
      enable = true;
      enableFishIntegration = true;
      useTheme = "ys";
    };
  };
}
