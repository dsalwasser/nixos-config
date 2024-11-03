# This is the configuration file for the KDE Plasma desktop environment.

{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    xkb.layout = "de";

    excludePackages = [ pkgs.xterm ];
  };

  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  services.desktopManager.plasma6.enable = true;

  # Excluding some KDE Plasma applications from the default install.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    gwenview
    kate
    khelpcenter
    konsole
    okular
  ];

  # Add the KDE xdg desktop portal backend.
  xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];

  # Needed for anything GTK related.
  programs.dconf.enable = true;
}
