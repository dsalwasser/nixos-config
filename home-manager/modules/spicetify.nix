{ inputs, pkgs, ... }: {
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      spotifyPackage = pkgs.additions.spotify-adblock;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        autoSkipVideo
        loopyLoop
        hidePodcasts
        shuffle
      ];
      theme = spicePkgs.themes.comfy;
    };
}
