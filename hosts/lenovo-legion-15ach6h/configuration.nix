{
  config,
  inputs,
  pkgs,
  ...
}: {
  # Make the additional packages and package modifications from this flake
  # available.
  nixpkgs.overlays = [
    inputs.self.overlays.additions
    inputs.self.overlays.modifications
  ];

  components = {
    # Use modern Nix settings.
    nix.enable = true;

    # Enable impermanence to wipe the root directory every reboot.
    impermanence.enable = true;

    # Enable the audio subsystem component.
    audio.enable = true;

    # Enable the Bluetooth subsystem component.
    bluetooth.enable = true;

    # Enable the networking subsystem component.
    networking.enable = true;

    # Enable the printing subsystem component.
    printing.enable = true;

    # Enable the virtualization subsystem component.
    virtualization.enable = true;

    # Enable Plymouth to have a a flicker-free graphical boot process.
    plymouth.enable = true;

    # Use KDE Plasma as the desktop environment.
    kde-plasma.enable = true;

    # Use Home Manager to configure the users.
    home-manager = {
      enable = true;
      users.sali = ./home-configuration.nix;
    };
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;

    # Store the key used for secret decryption in a persisted directory,
    # otherwise the impermanence module would wipe it on reboot.
    age.keyFile = "/persist/var/lib/sops-nix/keys.txt";

    # Since sops-nix has to run after NixOS creates users, do not set an owner
    # for these secrets and decrypt them to ´/run/secrets-for-users´ instead of
    # ´/run/secrets´ before NixOS creates users.
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

  # Enable the fish shell so that it can be set as the default shell.
  programs.fish.enable = true;

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
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

  # Set the hostname of this device to `nixos`.
  networking.hostName = "nixos";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
