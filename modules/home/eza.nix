{
  config,
  lib,
  ...
}: let
  cfg = config.components.home.eza;
in {
  options.components.home.eza = {
    enable = lib.mkEnableOption "Whether to enable eza.";
  };

  config = lib.mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableFishIntegration = true;

      extraOptions = [
        "--long"
        "--all"
        "--group-directories-first"
        "--header"
      ];
      git = true;
    };
  };
}
