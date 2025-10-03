{ config, inputs, lib, pkgs, ... }: {
  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command.
        experimental-features = "nix-command flakes";

        # Deduplicate and optimize nix store.
        auto-optimise-store = true;

        # Workaround for https://github.com/NixOS/nix/issues/9574.
        nix-path = config.nix.nixPath;
      };

      # This will add each flake input as a registry to make nix3 commands
      # consistent with your flake.
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;

      # This will additionally add your inputs to the system's legacy channels.
      # Making legacy nix commands consistent as well!
      nixPath = lib.mapAttrsToList (key: value: "${key}=flake:${key}") flakeInputs;
    };

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./file-systems.nix
    ./kde-plasma.nix
    ./networking.nix
  ];

  networking.hostName = "nixos";

  time = {
    timeZone = "Europe/Berlin";

    # Setting RTC time standard to localtime, compatible with Windows in its
    # default configuration.
    hardwareClockInLocalTime = true;
  };

  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  users.users.sali = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "sound" "docker" "podman" "libvirtd" ];
    shell = pkgs.fish;
  };

  programs = {
    fish.enable = true;
    nix-ld.enable = true;
    ssh.startAgent = true;
  };

  # Enable iOS backup and filesystem support.
  services.usbmuxd.enable = true;
  environment.systemPackages = [ pkgs.libimobiledevice ];

  services = {
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
  };

  # Enable the RealtimeKit system service. The PipeWire and PulseAudio server
  # uses this to acquire realtime priority.
  security.rtkit.enable = true;

  security.lsm = lib.mkForce [ ];

  virtualisation = {
    containers.enable = true;

    docker = {
      enable = true;
      storageDriver = "btrfs";

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    podman = {
      enable = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };

    # Enable libvirt, a tool for managing platform virtualization
    libvirtd = {
      enable = true;

      # Add VirtioFS to mount shared filesystems between host and guest
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };

    # Enable the SPICE USB redirection helper, which allows unprivileged users
    # to pass USB devices connected to this machine to libvirt VMs, both local
    # and remote. Note that this allows users arbitrary access to USB devices.
    spiceUSBRedirection.enable = true;
  };

  hardware.bluetooth.enable = true;

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Register ARM64 binary format and allow the use of it inside containers.
    binfmt = {
      emulatedSystems = [ "aarch64-linux" ];
      preferStaticEmulators = true;
    };
  };

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
