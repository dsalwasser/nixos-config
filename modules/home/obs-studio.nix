{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.components.home.obs-studio;
in {
  options.components.home.obs-studio = {
    enable = lib.mkEnableOption "Whether to enable OBS Studio.";
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;

      package = pkgs.obs-studio.override {
        cudaSupport = true;
      };

      plugins = with pkgs.obs-studio-plugins; [
        obs-gstreamer
        obs-pipewire-audio-capture
        obs-vaapi
      ];
    };
  };
}
