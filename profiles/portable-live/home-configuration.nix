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

    # Add Firefox as a browser.
    firefox = {
      enable = true;
      makeDefaultBrowser = true;
    };

    # Configure KDE Plasma and VSCode.
    kde-plasma.enable = true;
    vscode.enable = true;
  };

  home.packages = with pkgs; [
    # Command-line tools
    bottom
    restic

    # Formatters
    alejandra

    # Desktop applications
    bitwarden-desktop
    tor-browser
    yubioath-flutter
  ];

  # Setup the fonts used by the system.
  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      serif = ["Noto Sans"];
      sansSerif = ["Noto Sans"];
      monospace = ["Noto Mono"];
      emoji = ["Noto Color Emoji"];
    };

    antialiasing = true;
    hinting = "slight";
    subpixelRendering = "rgb";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
