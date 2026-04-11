{
  inputs,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    "${toString modulesPath}/profiles/base.nix"
  ];

  nixpkgs.overlays = [
    inputs.self.overlays.additions
    inputs.self.overlays.modifications
  ];

  components = {
    # Use modern Nix settings.
    nix.enable = true;

    # Enable the audio subsystem component.
    audio.enable = true;

    # Enable the networking subsystem component.
    networking.enable = true;

    # Enable Plymouth to have a a flicker-free graphical boot process.
    plymouth.enable = true;

    # Use KDE Plasma as the desktop environment.
    kde-plasma = {
      enable = true;
      autoLoginUser = "nixos";
    };

    # Use Home Manager to configure the users.
    home-manager = {
      enable = true;
      users.nixos = ./home-configuration.nix;
    };
  };

  users = {
    # Set the default shell to fish.
    defaultUserShell = pkgs.fish;

    # Disable manual user configuration.
    mutableUsers = false;

    users = {
      root = {
        isSystemUser = true;
        # Lock the root user account.
        hashedPassword = "!";
      };

      nixos = {
        isNormalUser = true;
        # This user does not require a password.
        initialHashedPassword = "";
        extraGroups = ["wheel" "networkmanager"];
      };
    };
  };

  # Enable the fish shell so that it can be set as the default shell.
  programs.fish.enable = true;

  security = {
    # Don't require sudo/root to `reboot` or `poweroff`.
    polkit.enable = true;

    # Enable feedback when typing sudo passwords.
    sudo.extraConfig = "Defaults pwfeedback";
  };

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

  # Set the hostname of this device to `installer`.
  networking.hostName = "installer";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
