{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.components.kde-plasma;
in {
  options.components.kde-plasma = {
    enable = lib.mkEnableOption "Whether to enable KDE Plasma.";
    autoLoginUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Username to log in automatically to KDE Plasma. Set to null to disable autologin.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = false;
      };

      displayManager = {
        plasma-login-manager.enable = true;
        autoLogin = lib.mkIf (cfg.autoLoginUser != null) {
          enable = true;
          user = cfg.autoLoginUser;
        };
      };
    };

    xdg.portal = {
      config.common.default = "kde";
      xdgOpenUsePortal = true;
    };

    programs = {
      kdeconnect.enable = true;
      partition-manager.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [
        wayland-utils
        wl-clipboard
      ];

      plasma6.excludePackages = with pkgs.kdePackages; [
        discover
        elisa
        kate
        konsole
        khelpcenter
        ktexteditor
        kwin-x11
        okular
      ];
    };
  };
}
