{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;

    extraOptions = [
      "--long"
      "--all"
      "--group-directories-first"
      "--header"
    ];
    git = true;
  };
}
