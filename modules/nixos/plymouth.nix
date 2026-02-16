{
  config,
  lib,
  ...
}: let
  cfg = config.components.plymouth;
in {
  options.components.plymouth = {
    enable = lib.mkEnableOption "Whether to enable Plymouth.";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      plymouth.enable = true;

      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
      ];
    };
  };
}
