{
  config,
  lib,
  ...
}: let
  cfg = config.components.home.kde-plasma;
in {
  options.components.home.kde-plasma = {
    enable = lib.mkEnableOption "Whether to enable KDE Plasma.";
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
        "kwin" = {
          Overview = "Meta+Tab";
          ExposeAll = "Meta+CapsLock";
        };
      };

      panels = [
        # Windows-like panel at the bottom
        {
          location = "bottom";
          hiding = "dodgewindows";
          floating = false;
          widgets = [
            "org.kde.plasma.kickoff"
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

      configFile = {
        # Disable the Baloo file indexer.
        baloofilerc."Basic Settings"."Indexing-Enabled" = false;

        # Set the default terminal emulator to Alacritty.
        kdeglobals.General = {
          TerminalApplication = "alacritty";
          TerminalService = "Alacritty.desktop";
        };
      };
    };
  };
}
