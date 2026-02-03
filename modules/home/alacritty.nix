{
  config,
  lib,
  ...
}: let
  cfg = config.components.home.alacritty;
in {
  options.components.home.alacritty = {
    enable = lib.mkEnableOption "Whether to enable Alacritty.";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        font.size = 12;

        keyboard.bindings = [
          {
            key = "F11";
            action = "ToggleFullscreen";
          }
          {
            key = "PageUp";
            action = "ScrollPageUp";
          }
          {
            key = "PageDown";
            action = "ScrollPageDown";
          }
        ];

        window.dynamic_padding = true;
      };
    };
  };
}
