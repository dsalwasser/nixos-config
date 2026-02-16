{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.components.home.gpg;
in {
  options.components.home.gpg = {
    enable = lib.mkEnableOption "Whether to enable GnuPG.";
  };

  config = lib.mkIf cfg.enable {
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      enableFishIntegration = true;
      pinentry.package = pkgs.pinentry-qt;
    };
  };
}
