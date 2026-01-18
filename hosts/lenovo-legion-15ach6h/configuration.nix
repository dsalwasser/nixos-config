{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.self.nixosModules.combined
  ];

  components = {
    # Enable the audio subsystem component.
    audio.enable = true;

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

  # Set the hostname of this device to `nixos`.
  networking.hostName = "nixos";

  # Set the default timezone to the German time. Also set RTC time standard to
  # localtime, compatible with Windows in its default configuration.
  time.timeZone = "Europe/Berlin";
  time.hardwareClockInLocalTime = true;

  # Set the console keyboard layout to German.
  console.keyMap = "de";

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

  # Enable a single user account named `sali`.
  users.users.sali = {
    # Set this account for a “real” user.
    isNormalUser = true;

    # Add this user to `wheel` to grant sudo privileges.
    extraGroups = ["audio" "docker" "kvm" "libvirtd" "networkmanager" "wheel"];

    # Set the default shell to fish.
    shell = pkgs.fish;
  };

  # Enable the fish shell.
  programs.fish.enable = true;
}
