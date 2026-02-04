{
  audio = import ./audio.nix;
  bluetooth = import ./bluetooth.nix;
  combined = import ./combined.nix;
  home-manager = import ./home-manager.nix;
  impermanence = import ./impermanence.nix;
  kde-plasma = import ./kde-plasma.nix;
  networking = import ./networking.nix;
  nix = import ./nix.nix;
  plymouth = import ./plymouth.nix;
  printing = import ./printing.nix;
  virtualization = import ./virtualization.nix;
}
