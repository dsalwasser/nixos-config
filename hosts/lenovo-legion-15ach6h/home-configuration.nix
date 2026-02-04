{pkgs, ...}: {
  components.home = {
    alacritty.enable = true;
    eza.enable = true;
    fish.enable = true;
    git.enable = true;
    helix.enable = true;
    zellij.enable = true;
    firefox = {
      enable = true;
      makeDefaultBrowser = true;
    };
    vscode.enable = true;
    kde-plasma.enable = true;
  };

  home.packages = with pkgs; [
    # Command-line tools
    bottom
    gnupg
    nix-your-shell
    quickemu
    restic

    # Formatters and language servers
    alejandra
    bash-language-server
    clang-tools
    cmake-language-server
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
    new-york
    sf-mono
    sf-pro
  ];

  # Setup the fonts used by the system.
  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      serif = ["SF Pro Text"];
      sansSerif = ["SF Pro Text"];
      monospace = ["SF Mono"];
      emoji = ["Noto Color Emoji"];
    };

    antialiasing = true;
    hinting = "slight";
    subpixelRendering = "rgb";
  };

  # Point Ipe to the the directory containing `pdflatex` and `xelatex`.
  home.sessionVariables.IPELATEXPATH = "${pkgs.tex}/bin/";

  # Enable file database for nixpkgs.
  programs.nix-index.enable = true;

  # Enable GnuPG private key agent and change the Pinentry interface to work with KDE Plasma.
  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
