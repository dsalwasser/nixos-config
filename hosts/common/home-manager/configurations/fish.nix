{pkgs, ...}: {
  # Alternative shell to bash.
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Disable greeting
      set fish_greeting

      # Use fish instead of bash as the default shell when using `nix develop`, etc.
      ${pkgs.nix-your-shell}/bin/nix-your-shell fish | source

      # Ensure `SHELL` points to fish so programs detect the correct login shell.
      set -x SHELL (which fish)
    '';
  };

  # Shell prompt renderer.
  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = true;
    useTheme = "ys";
  };
}
