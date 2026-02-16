{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.components.home.git;
in {
  options.components.home.git = {
    enable = lib.mkEnableOption "Whether to enable Git.";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      settings.init.defaultBranch = "main";
      settings.user = {
        email = "daniel.salwasser@outlook.com";
        name = "Daniel Salwasser";
      };

      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGzE9O1OSxK/2qYqfSePD49L5HEjiN0nd5s18qNct28o daniel.salwasser@outlook.com";
        format = "ssh";
        signByDefault = true;
        signer = "${pkgs.openssh}/bin/ssh-keygen";
      };
    };

    programs.lazygit = {
      enable = true;
      settings.git.autoFetch = false;
    };
  };
}
