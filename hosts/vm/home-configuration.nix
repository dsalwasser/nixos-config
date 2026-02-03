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

  # Setup the fonts used by the system and the rendering modes.
  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      serif = ["SF Pro Text"];
      sansSerif = ["New York"];
      monospace = ["SF Mono"];
      emoji = ["Noto Color Emoji"];
    };

    antialias = true;
    hinting = "slight";
    subpixelRendering = "rgb";
  };

  # Include the system fonts.
  home.packages = with pkgs; [sf-mono sf-pro new-york];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
