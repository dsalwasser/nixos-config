{ ... }: {
  programs.plasma = {
    enable = true;

    workspace.lookAndFeel = "org.kde.breezedark.desktop";

    fonts = {
      general = {
        family = "SF Pro Text";
        pointSize = 11;
      };

      fixedWidth = {
        family = "SF Mono";
        pointSize = 11;
      };

      small = {
        family = "SF Pro Text";
        pointSize = 8;
      };

      toolbar = {
        family = "SF Pro Text";
        pointSize = 10;
      };

      menu = {
        family = "SF Pro Text";
        pointSize = 10;
      };

      windowTitle = {
        family = "SF Pro Text";
        pointSize = 10;
      };
    };
  };
}
 