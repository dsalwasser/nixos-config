{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "nix-hash";

    text = ''
      if [ "$#" -ne 1 ]; then
        echo "Error: Invalid number of arguments."
        echo "Usage: nix run .#nix-hash -- <URL>"
        exit 1
      fi

      URL="$1"

      # Fetch the file and get the legacy nix32 hash
      # This downloads the file to the Nix store temporarily
      NIX32_HASH=$(nix-prefetch-url --type sha256 "$URL")

      if [ -z "$NIX32_HASH" ]; then
        echo "Error: Failed to fetch the URL."
        exit 1
      fi

      # Convert the nix32 hash to the modern SRI (sha256-...) format
      SRI_HASH=$(nix hash convert --hash-algo sha256 --from nix32 "$NIX32_HASH")

      echo "$SRI_HASH"
    '';
  };
in {
  type = "app";
  program = "${script}/bin/nix-hash";
}
