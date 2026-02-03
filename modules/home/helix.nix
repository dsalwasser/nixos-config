{
  config,
  lib,
  ...
}: let
  cfg = config.components.home.helix;
in {
  options.components.home.helix = {
    enable = lib.mkEnableOption "Whether to enable Helix.";
  };

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;

      languages.language = [
        {
          name = "nix";
          formatter.command = "alejandra";
        }
        {
          name = "cpp";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }
      ];

      settings = {
        editor = {
          color-modes = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides.render = true;
          lsp.display-messages = true;
        };

        keys.normal = {
          C-y = "goto_prev_function";
          C-x = "goto_next_function";

          A-y = "goto_prev_class";
          A-x = "goto_next_class";

          A-w = "goto_definition";
        };
      };
    };
  };
}
