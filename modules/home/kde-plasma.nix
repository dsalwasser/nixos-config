{
  config,
  lib,
  ...
}: let
  cfg = config.components.home.kde-plasma;
in {
  options.components.home.kde-plasma = {
    enable = lib.mkEnableOption "Whether to enable the KDE Plasma config.";
  };

  config = lib.mkIf cfg.enable {
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

      input.keyboard.layouts = [
        {
          layout = "de";
        }
        {
          layout = "us";
        }
      ];

      shortcuts = {
        "services/vicinae.desktop"."open" = "Meta+Space";
      };

      panels = [
        # Windows-like panel at the bottom
        {
          location = "bottom";
          hiding = "dodgewindows";
          floating = false;
          widgets = [
            # We can configure the widgets by adding the name and config
            # attributes. For example to add the the kickoff widget and set the
            # icon to "nix-snowflake-white" use the below configuration. This will
            # add the "icon" key to the "General" group for the widget in
            # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
            {
              name = "org.kde.plasma.kickoff";
            }
            {
              iconTasks = {
                launchers = [
                  "applications:systemsettings.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "applications:firefox.desktop"
                  "applications:Alacritty.desktop"
                  "applications:codium.desktop"
                ];
              };
            }
            "org.kde.plasma.marginsseparator"
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
            "org.kde.plasma.showdesktop"
          ];
        }
      ];

      # Disable the Baloo file indexer.
      configFile.baloofilerc."Basic Settings"."Indexing-Enabled" = false;
    };

    # Alternative desktop launcher to KRunner.
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
    };

    # Enable Ozone Wayland support in Chromium and Electron based applications.
    home.sessionVariables.NIXOS_OZONE_WL = 1;
  };
}
