{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;

    layouts.default = pkgs.replaceVars ../assets/layout.kdl {
      zjstatus_path = "${pkgs.zjstatus}/bin/zjstatus.wasm";
    };

    settings = {
      # Disable Tmux mode.
      keybinds.unbind = "Ctrl b";

      # Change UI settings.
      pane_frames = false;
      show_startup_tips = false;
      ui.pane_frames.hide_session_name = true;
    };
  };
}
