{
  config,
  lib,
  ...
}: let
  cfg = config.components.printing;
in {
  options.components.printing = {
    enable = lib.mkEnableOption "Enable the printing subsystem.";
  };

  config = lib.mkIf cfg.enable {
    # Enable printing functionality.
    services = {
      printing.enable = true;

      # Run the Avahi daemon to detect printers which support the IPP
      # Everywhere protocol.
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
