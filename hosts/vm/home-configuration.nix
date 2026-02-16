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

    # Enable Git.
    git.enable = true;

    # Enable Firefox as the default browser.
    firefox = {
      enable = true;
      makeDefaultBrowser = true;
    };

    # Configure KDE Plasma.
    kde-plasma.enable = true;
  };

  # Include the system fonts.
  home.packages = with pkgs; [sf-mono sf-pro];

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
