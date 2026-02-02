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

    # Enable impermanence to wipe the root directory every reboot.
    impermanence.enable = true;

    # Enable UEFI Secure Boot.
    secure-boot.enable = true;

    # Enable KDE Plasma as the desktop environment.
    kde-plasma.enable = true;

    # Enable the networking subsystem component.
    networking.enable = true;

    # Enable Plymouth to have a a flicker-free graphical boot process.
    plymouth.enable = true;
  };

  users = {
    # Set the default shell to fish.
    defaultUserShell = pkgs.fish;

    # Disable manual user configuration.
    mutableUsers = false;

    users = {
      root.password = "123";

      sali = {
        isNormalUser = true;
        password = "test";
        extraGroups = ["audio" "networkmanager" "fuse" "wheel"];
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
}
