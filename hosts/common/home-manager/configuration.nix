{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs = {
    config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [
        "spotify"
        "sf-pro"
        "sf-mono"
      ];

    overlays = [
      # Include the packages defined by this flake.
      inputs.self.overlays.additions
      inputs.self.overlays.modifications

      # Use TexLive as the tex distribution, containing every package.
      (final: prev: {
        tex = final.texlive.combine {
          inherit (final.texlive) scheme-full;
        };
      })
    ];
  };

  # Allow fontconfig to discover fonts and configurations installed through `home.packages`.
  fonts.fontconfig.enable = true;

  imports = [
    ./configurations/alacritty.nix
    ./configurations/distrobox.nix
    ./configurations/eza.nix
    ./configurations/firefox.nix
    ./configurations/fish.nix
    ./configurations/git.nix
    ./configurations/helix.nix
    ./configurations/plasma.nix
    ./configurations/spicetify.nix
    ./configurations/virtualization.nix
    ./configurations/vscode.nix
    ./configurations/zellij.nix
  ];

  home.packages = with pkgs; [
    # Command-line tools
    bottom
    gnupg
    quickemu
    nix-your-shell
    restic

    # Formatters and language servers
    alejandra
    bash-language-server
    cmake-language-server
    clang-tools
    marksman
    nil
    texlab

    # Desktop applications
    bitwarden-desktop
    chromium
    easyeffects
    inkscape
    ipe
    mpv
    pympress
    signal-desktop
    thunderbird
    tor-browser
    yubioath-flutter

    # Fonts
    sf-mono
    sf-pro
  ];

  # Point Ipe to the the directory containing `pdflatex` and `xelatex`.
  home.sessionVariables.IPELATEXPATH = "${pkgs.tex}/bin/";

  home = {
    username = "sali";
    homeDirectory = "/home/sali";
  };

  # Enable file database for nixpkgs.
  programs.nix-index.enable = true;

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  # Enable GnuPG private key agent and change the Pinentry interface to work with KDE Plasma.
  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  # Nicely reload system units when changing configs.
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
