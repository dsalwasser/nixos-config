{
  stdenv,
  lib,
  fetchurl,
}:
stdenv.mkDerivation {
  name = "zjstatus";
  version = "0.22.0";

  src = fetchurl {
    url = "https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm";
    hash = "sha256-TeQm0gscv4YScuknrutbSdksF/Diu50XP4W/fwFU3VM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/zjstatus.wasm
  '';

  meta = {
    homepage = "https://github.com/dj95/zjstatus/";
    description = "Configurable statusbar plugin for Zellij";
    license = lib.licenses.mit;
  };
}
