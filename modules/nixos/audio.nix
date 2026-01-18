{
  config,
  lib,
  ...
}: let
  cfg = config.components.audio;
in {
  options.components.audio = {
    enable = lib.mkEnableOption "Enable the audio subsystem.";
  };

  config = lib.mkIf cfg.enable {
    # Use PipeWire as the audio subsystem.
    services.pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      # Enable PulseAudio server emulation.
      pulse.enable = true;
    };

    # Enable the RealtimeKit system service. The PipeWire and PulseAudio server
    # uses this to acquire realtime priority.
    security.rtkit.enable = true;
  };
}
