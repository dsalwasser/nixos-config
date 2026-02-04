{pkgs, ...}: {
  components = {
    # Enable the audio subsystem component.
    audio.enable = true;

    # Enable the Bluetooth subsystem component.
    bluetooth.enable = true;

    # Enable Home Manager to configure the users.
    home-manager = {
      enable = true;
      users.sali = ./home-configuration.nix;
    };

    # Enable KDE Plasma as the desktop environment.
    kde-plasma.enable = true;

    # Enable the networking subsystem component.
    networking.enable = true;

    # Enable Plymouth to have a a flicker-free graphical boot process.
    plymouth.enable = true;

    # Enable the printing subsystem component.
    printing.enable = true;

    # Enable the virtualization subsystem component.
    virtualization.enable = true;
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

  # Enable a single user account named `sali`.
  users.users.sali = {
    isNormalUser = true;
    extraGroups = ["audio" "docker" "kvm" "libvirtd" "networkmanager" "wheel"];

    # Set the default shell to fish.
    shell = pkgs.fish;
  };

  # Enable the fish shell.
  programs.fish.enable = true;
}
