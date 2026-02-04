{
  config,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.self.overlays.additions
    inputs.self.overlays.modifications
  ];

  components = {
    # Enable the audio subsystem component.
    audio.enable = true;

    # Enable Home Manager to configure the users.
    home-manager = {
      enable = true;
      users.sali = ./home-configuration.nix;
    };

    # Enable impermanence to wipe the root directory every reboot.
    impermanence.enable = true;

    # Enable KDE Plasma as the desktop environment.
    kde-plasma.enable = true;

    # Enable the networking subsystem component.
    networking.enable = true;

    nix.enable = true;

    # Enable Plymouth to have a a flicker-free graphical boot process.
    plymouth.enable = true;
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/persist/var/lib/sops-nix/keys.txt";

    secrets = {
      root-password.neededForUsers = true;
      sali-password.neededForUsers = true;
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
        hashedPasswordFile = config.sops.secrets.root-password.path;
      };

      sali = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.sali-password.path;
        extraGroups = ["audio" "networkmanager" "fuse" "podman" "kvm" "libvirtd" "wheel"];
      };
    };
  };

  # Enable the fish shell.
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

  # Set the hostname of this device to `nixos`.
  networking.hostName = "nixos";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
