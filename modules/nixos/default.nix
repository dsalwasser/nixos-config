{
  audio = import ./audio.nix;
  bluetooth = import ./bluetooth.nix;
  combined = import ./combined.nix;
  kde-plasma = import ./kde-plasma.nix;
  networking = import ./networking.nix;
  plymouth = import ./plymouth.nix;
  printing = import ./printing.nix;
  virtualization = import ./virtualization.nix;
}
