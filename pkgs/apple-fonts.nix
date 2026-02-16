{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  p7zip,
}: let
  mkAppleFont = {
    name,
    pkgName,
    url,
    sha256,
  }:
    stdenvNoCC.mkDerivation {
      inherit name;

      src = fetchurl {inherit url sha256;};

      nativeBuildInputs = [undmg p7zip];

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

      meta = with lib; {
        description = "Apple's ${name} font family";
        homepage = "https://developer.apple.com/fonts/";
        platforms = platforms.all;
      };
    };

  fontData = {
    sf-mono = {
      pkgName = "SF Mono Fonts.pkg";
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
      sha256 = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
    };
    sf-pro = {
      pkgName = "SF Pro Fonts.pkg";
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
      sha256 = "sha256-W0sZkipBtrduInk0oocbFAXX1qy0Z+yk2xUyFfDWx4s=";
    };
  };
in
  lib.mapAttrs (name: cfg: mkAppleFont ({inherit name;} // cfg)) fontData
