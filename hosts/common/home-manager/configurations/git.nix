{
  programs.git = {
    enable = true;

    settings.init.defaultBranch = "main";
    settings.user = {
      email = "daniel.salwasser@outlook.com";
      name = "Daniel Salwasser";
    };

    signing = {
      key = "6CD20B2D0655BDF6";
      signByDefault = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings.git.autoFetch = false;
  };
}
