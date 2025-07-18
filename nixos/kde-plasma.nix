{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];

    xkb.layout = "de";
  };

  services = {
    desktopManager.plasma6.enable = true;

    displayManager = {
      defaultSession = "plasma";

      sddm = {
        enable = true;
        autoNumlock = true;
      };
    };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    gwenview
    kate
    khelpcenter
    konsole
    okular
  ];
}
