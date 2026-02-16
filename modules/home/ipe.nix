{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.components.home.ipe;
in {
  options.components.home.ipe = {
    enable = lib.mkEnableOption "Whether to enable Ipe.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.ipe];

    # Point Ipe to the the directory containing `pdflatex` and `xelatex`.
    home.sessionVariables.IPELATEXPATH = "${pkgs.tex}/bin/";
  };
}
