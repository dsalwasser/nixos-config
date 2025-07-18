{ ... }: {
  networking.useDHCP = true;

  virtualisation.virtualbox.guest.enable = true;
  fileSystems."/virtualboxshare" = {
    fsType = "vboxsf";
    device = "share";
    options = [ "rw" "nofail" ];
  };

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
