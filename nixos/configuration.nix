# This is the system's configuration file and is used to configure the system
# environment (it replaces /etc/nixos/configuration.nix)

{ config, inputs, lib, pkgs, ... }: {
  imports = [
    ./file-systems.nix
    ./kde-plasma.nix
  ];

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  nix = {
    # This will add each flake input as a registry to make nix3 commands
    # consistent with your flake.
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels.
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command.
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store.
      auto-optimise-store = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time = {
    timeZone = "Europe/Berlin";

    # Setting RTC time standard to localtime, compatible with Windows in its
    # default configuration.
    hardwareClockInLocalTime = true;
  };

  # Set the default locale and configure the virtual console keymap from the
  # xserver keyboard settings.
  i18n.defaultLocale = "de_DE.UTF-8";
  console.useXkbConfig = true;

  # Enable xdg desktop integration for securely accessing resources from
  # outside an application.
  xdg.portal.enable = true;

  # Start the OpenSSH agent on login.
  programs.ssh.startAgent = true;

  # Enable the fish shell.
  programs.fish.enable = true;

  users.users.sali = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "sound" "docker" ];
    shell = pkgs.fish;
  };

  services = {
    # Enable CUPS to print documents
    printing.enable = true;

    # Run the Avahi daemon to detect printers which support the IPP
    # Everywhere protocol.
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Enable audio via PipeWire.
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };

      # Enable PulseAudio server emulation.
      pulse.enable = true;
    };

    cloudflare-warp.enable = true;
  };

  # Enable the RealtimeKit system service. The PipeWire and PulseAudio server
  # uses this to acquire realtime priority.
  security.rtkit.enable = true;

  # Enable docker.
  virtualisation.docker.enable = true;

  # Enable support for bluetooth.
  hardware.bluetooth.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Configures the default timeout for stopping units.
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  # This option defines the first version of NixOS you have installed on this
  # particular machine, and is used to maintain compatibility with application
  # data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for
  # any reason, even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are
  # pulled from, so changing it will NOT upgrade your system - see
  # https://nixos.org/manual/nixos/stable/#sec-upgrading for how to actually do
  # that.
  #
  # This value being lower than the current NixOS release does NOT mean your
  # system is out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes
  # it would make to your configuration, and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.05"; # Did you read the comment?
}
