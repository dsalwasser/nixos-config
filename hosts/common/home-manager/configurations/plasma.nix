{...}: {
  programs.plasma = {
    enable = true;

    workspace.lookAndFeel = "org.kde.breezedark.desktop";

    fonts = {
      general = {
        family = "SF Pro Text";
        pointSize = 11;
      };

      fixedWidth = {
        family = "SF Mono";
        pointSize = 11;
      };

      small = {
        family = "SF Pro Text";
        pointSize = 8;
      };

      toolbar = {
        family = "SF Pro Text";
        pointSize = 10;
      };

      menu = {
        family = "SF Pro Text";
        pointSize = 10;
      };

      windowTitle = {
        family = "SF Pro Text";
        pointSize = 10;
      };
    };
  };

  # Alternative desktop launcher to KRunner.
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
  };

  # Disable the Baloo file indexer.
  home.file.".config/baloofilerc".source = ../assets/baloofilerc;

  # Enable Ozone Wayland support in Chromium and Electron based applications.
  home.sessionVariables.NIXOS_OZONE_WL = 1;
}
