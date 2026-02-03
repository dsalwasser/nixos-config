{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.components.home.zellij;
in {
  options.components.home.zellij = {
    enable = lib.mkEnableOption "Whether to enable Zellij.";
  };

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableFishIntegration = true;

      layouts.default = ''
        layout {
          default_tab_template {
            children
            pane size=1 borderless=true {
              plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
              format_left  "{mode} #[fg=#91d7e3,bold]{session} {tabs}"
              format_right "{datetime}"

              mode_normal "#[bg=#24273a,fg=#cad3f5] {name} "

              tab_normal "#[fg=#6C7086] {name} "
              tab_active "#[fg=#cad3f5,bold] {name} "

              datetime          "#[fg=#6C7086,bold] {format} "
              datetime_format   "%A, %d %b %Y %H:%M"
              datetime_timezone "Europe/Berlin"
              }
            }
          }
        }
      '';

      settings = {
        # Disable Tmux mode.
        keybinds.unbind = "Ctrl b";

        # Change UI settings.
        pane_frames = false;
        show_startup_tips = false;
        ui.pane_frames.hide_session_name = true;
      };
    };
  };
}
