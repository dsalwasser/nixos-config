{
  config,
  lib,
  ...
}: let
  cfg = config.components.home.chromium;
in {
  options.components.home.chromium = {
    enable = lib.mkEnableOption "Whether to enable Chromium.";
  };

  config = lib.mkIf cfg.enable {
    programs.chromium.enable = true;
  };
}
