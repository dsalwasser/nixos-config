{pkgs, ...}: {
  components.home = {
    alacritty.enable = true;
    eza.enable = true;
    fish.enable = true;
    git.enable = true;
    helix.enable = true;
    zellij.enable = true;

    chromium.enable = true;
    firefox.enable = true;
    vscode.enable = true;

    kde-plasma.enable = true;
  };

  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      serif = ["SF Pro Text"];
      monospace = ["SF Mono"];
    };
  };

  home.packages = with pkgs; [
    sf-mono
    sf-pro
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
