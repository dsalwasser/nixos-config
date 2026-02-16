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

    # Alternative desktop launcher to KRunner.
    programs.vicinae = {
      enable = true;
      systemd.enable = true;

      settings = {
        theme = {
          dark.name = "vicinae-dark";
        };
        launcher_window = {
          opacity = 0.98;
          client_side_decorations.enabled = true;
        };
        close_on_focus_loss = true;
        providers = {
          browser-extension.enabled = false;
          core.entrypoints = {
            documentation.enabled = false;
            keybind-settings.enabled = false;
            list-extensions.enabled = false;
            manage-fallback.enabled = false;
            oauth-token-store.enabled = false;
            open-config-file.enabled = false;
            open-default-config.enabled = false;
            reload-scripts.enabled = false;
            refresh-apps.enabled = false;
            report-bug.enabled = false;
            sponsor.enabled = false;
            store.enabled = false;
          };
          files.preferences.autoIndexing = false;
          developer.enabled = false;
          font.enabled = false;
          manage-shortcuts.enabled = false;
          power.entrypoints = {
            sleep.enabled = false;
            soft-reboot.enabled = false;
          };
          raycast-compat.enabled = false;
          theme.enabled = false;
          wm.enabled = false;
        };
      };
    };

    # Enable Ozone Wayland support in Chromium and Electron based applications.
    home.sessionVariables.NIXOS_OZONE_WL = 1;
  };
}
