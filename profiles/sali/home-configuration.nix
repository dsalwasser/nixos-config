{pkgs, ...}: {
  components.home = {
    # Use Alacritty as the terminal emulator.
    alacritty.enable = true;

    # Use Zellij as the terminal multiplexer.
    zellij.enable = true;

    # Use fish as the command line shell.
    fish.enable = true;

    # Use Helix as the text editor.
    helix.enable = true;

    # Use eza as an alternative to ls.
    eza.enable = true;

    # Enable Git and GnuPG.
    git.enable = true;
    gpg.enable = true;

    # Add chromium and firefox as browsers.
    chromium.enable = true;
    firefox = {
      enable = true;
      makeDefaultBrowser = true;
    };

    # Configure KDE Plasma, Ipe, and VSCode.
    kde-plasma.enable = true;
    obs-studio.enable = true;
    ipe.enable = true;
    vscode.enable = true;
  };

  home.packages = with pkgs; [
    # Command-line tools
    bottom
    nvtopPackages.full
    quickemu
    restic
    tex

    # Formatters and language servers
    alejandra
    bash-language-server
    clang-tools
    neocmakelsp
    nil
    texlab

    # Desktop applications
    antigravity
    bitwarden-desktop
    easyeffects
    inkscape
    kdePackages.kamoso
    mpv
    pympress
    signal-desktop
    thunderbird
    tor-browser
    trilium-desktop
    yubioath-flutter

    # Fonts
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

  # Integrate nix-index with the shell.
  programs.nix-index.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
