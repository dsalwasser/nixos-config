{pkgs, ...}: let
  makeAppleFont = name: pkgName: url: hash:
    pkgs.stdenvNoCC.mkDerivation {
      inherit name;

      src = pkgs.fetchurl {inherit url hash;};
      buildInputs = [pkgs.undmg pkgs.p7zip];

      setSourceRoot = "sourceRoot=`pwd`";

      unpackPhase = ''
        undmg $src
        7z x '${pkgName}'
        7z x 'Payload~'
      '';

      installPhase = ''
        mkdir -p $out/share/fonts
        mkdir -p $out/share/fonts/opentype
        mkdir -p $out/share/fonts/truetype
        find -name \*.otf -exec mv {} $out/share/fonts/opentype/ \;
        find -name \*.ttf -exec mv {} $out/share/fonts/truetype/ \;
      '';

      meta = {
        homepage = "https://developer.apple.com/fonts/";
        description = ''
          San Francisco is an Apple designed typeface that provides
          a consistent, legible, and friendly typographic voice.
        '';
      };
    };
in {
  sf-mono =
    makeAppleFont "sf-mono"
    "SF Mono Fonts.pkg"
    "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg"
    "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";

  sf-pro =
    makeAppleFont "sf-pro"
    "SF Pro Fonts.pkg"
    "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg"
    "sha256-u7cLbIRELSNFUa2OW/ZAgIu6vbmK/8kXXqU97xphA+0=";

  new-york =
    makeAppleFont "new-york"
    "NY Fonts.pkg"
    "https://devimages-cdn.apple.com/design/resources/download/NY.dmg"
    "sha256-HC7ttFJswPMm+Lfql49aQzdWR2osjFYHJTdgjtuI+PQ=";
}
