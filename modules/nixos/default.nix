{
  audio = import ./audio.nix;
  bluetooth = import ./bluetooth.nix;
  combined = import ./combined.nix;
  impermanence = import ./impermanence.nix;
  kde-plasma = import ./kde-plasma.nix;
  networking = import ./networking.nix;
  plymouth = import ./plymouth.nix;
  printing = import ./printing.nix;
  secure-boot = import ./secure-boot.nix;
  virtualization = import ./virtualization.nix;
}
