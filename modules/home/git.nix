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
        key = "${config.home.homeDirectory}/.ssh/id_ed25519_sk_yubikey1.pub";
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
