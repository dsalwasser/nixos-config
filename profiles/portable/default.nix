{pkgs, ...}: {
  components = {
    # Enables hardened offline mode by restricting connectivity.
    airgap.enable = true;

    # Enable Plymouth to have a a flicker-free graphical boot process.
    plymouth.enable = true;

    # Use KDE Plasma as the desktop environment.
    kde-plasma = {
      enable = true;
      autoLoginUser = "sali";
    };
  };

  users = {
    # Set the default shell to fish.
    defaultUserShell = pkgs.fish;

    users = {
      root = {
        isSystemUser = true;
        initialPassword = "apple";
      };

      sali = {
        isNormalUser = true;
        initialPassword = "apple";
        uid = 1000;
        extraGroups = ["wheel"];

        packages = with pkgs; [alacritty helix trilium-desktop];
      };
    };
  };

  # Enable the fish shell so that it can be set as the default shell.
  programs.fish.enable = true;

  # Set the internationalization properties to German standards.
  i18n = {
    defaultLocale = "de_DE.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  # Set the console keyboard layout to German.
  console.keyMap = "de";

  # Set the default timezone to the German time.
  time.timeZone = "Europe/Berlin";

  # Set the hostname of this device to `nomade`.
  networking.hostName = "nomade";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
