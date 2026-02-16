{...}: {
  # Include the custom packages from the "pkgs" directory.
  additions = final: _: import ../pkgs final.pkgs;

  modifications = final: prev: {
    # Use TexLive as the tex distribution, containing every package.
    tex = final.texlive.combine {
      inherit (final.texlive) scheme-full;
    };
  };
}
