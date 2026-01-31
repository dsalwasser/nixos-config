{
  audio = import ./audio.nix;
  combined = import ./combined.nix;
  impermanence = import ./impermanence.nix;
  kde-plasma = import ./kde-plasma.nix;
  networking = import ./networking.nix;
  plymouth = import ./plymouth.nix;
  printing = import ./printing.nix;
  virtualization = import ./virtualization.nix;
}
