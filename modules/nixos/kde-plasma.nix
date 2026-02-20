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
    services = {
      desktopManager.plasma6.enable = true;

      displayManager.sddm = {
        enable = true;
        autoNumlock = true;

        wayland = {
          enable = true;
          compositor = "kwin";
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
