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
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      xkb.layout = "de";
    };

    services = {
      desktopManager.plasma6.enable = true;

      displayManager = {
        defaultSession = "plasma";

        sddm = {
          enable = true;
          autoNumlock = true;

          wayland = {
            enable = true;
            compositor = "kwin";
          };
        };
      };
    };

    environment = {
      systemPackages = with pkgs; [
        kdePackages.sddm-kcm
        wayland-utils
        wl-clipboard
      ];

      plasma6.excludePackages = with pkgs.kdePackages; [
        elisa
        kate
        konsole
        khelpcenter
        ktexteditor
        okular
      ];
    };
  };
}
