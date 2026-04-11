{...}: {
  # Include the custom packages from the "pkgs" directory.
  additions = final: _: import ../pkgs final.pkgs;

  modifications = final: prev: {
    # Use TexLive as the tex distribution, containing every package.
    tex = final.texlive.combine {
      inherit (final.texlive) scheme-full;
    };

    # Enables MPRIS integration so MPV can expose playback controls and
    # metadata via D-Bus.
    mpv = prev.mpv.override {
      scripts = [final.mpvScripts.mpris];
    };
  };
}
