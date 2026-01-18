{
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal.family = "SF Mono";
        size = 11;
      };

      keyboard.bindings = [
        {
          key = "F11";
          action = "ToggleFullscreen";
        }
        {
          key = "PageUp";
          action = "ScrollPageUp";
        }
        {
          key = "PageDown";
          action = "ScrollPageDown";
        }
      ];

      window.dynamic_padding = true;
    };
  };
}
