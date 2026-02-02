{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.components.secure-boot;
in {
  options.components.secure-boot = {
    enable = lib.mkEnableOption "Enable secure boot.";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";

        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          autoReboot = true;
        };
      };

      # Lanzaboote currently replaces the systemd-boot module. This setting is
      # usually set to true. So we force it to false for now.
      loader.systemd-boot.enable = lib.mkForce false;
    };

    # For debugging and troubleshooting Secure Boot.
    environment.systemPackages = [pkgs.sbctl];
  };
}
