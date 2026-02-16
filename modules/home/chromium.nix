{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.components.home.chromium;
in {
  options.components.home.chromium = {
    enable = lib.mkEnableOption "Whether to enable Chromium.";
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;

      commandLineArgs = [
        "--disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled"
      ];

      extensions = [
        # uBlock Origin
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}

        # Bitwarden
        {id = "nngceckbapebfimnlniiiahkandclblb";}
      ];

      nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
      ];
    };
  };
}
