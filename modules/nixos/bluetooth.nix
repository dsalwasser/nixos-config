{
  config,
  lib,
  ...
}: let
  cfg = config.components.bluetooth;
in {
  options.components.bluetooth = {
    enable = lib.mkEnableOption "Whether to enable the Bluetooth subsystem.";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
  };
}
