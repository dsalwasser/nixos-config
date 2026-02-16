pkgs: let
  apple-fonts = pkgs.callPackage ./apple-fonts.nix {};
in {
  sf-pro = apple-fonts.sf-pro;
  sf-mono = apple-fonts.sf-mono;
  zjstatus = pkgs.callPackage ./zjstatus.nix {};
}
