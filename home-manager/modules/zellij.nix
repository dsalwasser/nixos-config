{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.programs.zellij;
  insertSymbolsIntoLayout = file:
    builtins.replaceStrings
      [ "{ZJSTATUS_PATH}" ]
      [ "${pkgs.additions.zjstatus}/bin/zjstatus.wasm" ]
      (builtins.readFile file);
in
{
  options.programs.zellij = {
    layout = mkOption {
      type = types.path;
      default = { };
    };
  };

  config = mkIf (cfg.enable && cfg.layout != { }) {
    xdg.configFile."zellij/layouts/default.yaml" = mkIf (versionOlder cfg.package.version "0.32.0") {
      text = insertSymbolsIntoLayout cfg.layout;
    };

    xdg.configFile."zellij/layouts/default.kdl" = mkIf (versionAtLeast cfg.package.version "0.32.0") {
      text = insertSymbolsIntoLayout cfg.layout;
    };
  };
}
