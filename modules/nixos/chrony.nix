{
  config,
  lib,
  ...
}: let
  cfg = config.components.chrony;
in {
  options.components.chrony = {
    enable = lib.mkEnableOption "Whether to use chrony for time synchronization.";
  };

  config = lib.mkIf cfg.enable {
    services.chrony = {
      enable = true;
      enableNTS = true;
      servers = [
        "ptbtime1.ptb.de"
        "ptbtime2.ptb.de"
        "ptbtime3.ptb.de"
        "ptbtime4.ptb.de"
        "time.dfm.dk"
        "time.cloudflare.com"
      ];
    };
  };
}
