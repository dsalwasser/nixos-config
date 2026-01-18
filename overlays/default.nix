{
  # Include the custom packages from the "pkgs" directory.
  additions = final: _: import ../pkgs final.pkgs;

  modifications = final: prev: {
    quickemu = prev.quickemu.overrideAttrs {
      version = "4.9.7-unstable-2025-12-10";
      src = final.fetchFromGitHub {
        owner = "quickemu-project";
        repo = "quickemu";
        rev = "402ce974515b3c409c8648a1ac5ec6b48ee6c835";
        hash = "sha256-3NEupBOOeZLgd6lYmiLGN1ngDRH98g7JgALac3mXMKk=";
      };
      patches = [];
    };
  };
}
