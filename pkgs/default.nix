pkgs: let
  apple-fonts = pkgs.callPackage ./apple-fonts.nix {};
in {
  sf-pro = apple-fonts.sf-pro;
  sf-mono = apple-fonts.sf-mono;
  new-york = apple-fonts.new-york;
  spotify-adblock = pkgs.callPackage ./spotify-adblock.nix {};
  zen-browser = pkgs.callPackage ./zen-browser.nix {};
  zjstatus = pkgs.callPackage ./zjstatus.nix {};
}
