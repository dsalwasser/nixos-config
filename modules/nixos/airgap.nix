{
  config,
  lib,
  ...
}: let
  cfg = config.components.airgap;
in {
  options.components.airgap = {
    enable = lib.mkEnableOption "Whether to enable the strict air-gap mode.";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      # Disable networking functionality
      networkmanager.enable = lib.mkForce false;
      wireless.enable = lib.mkForce false;
      useDHCP = lib.mkForce false;

      # Force-clear all interfaces except loopback (lo)
      interfaces = lib.mkForce {};

      # Drop all traffic by default (Inbound, Forward, & Outbound)
      firewall = {
        enable = lib.mkForce true;
        allowPing = lib.mkForce false;
        allowedTCPPorts = lib.mkForce [];
        allowedUDPPorts = lib.mkForce [];
        extraCommands = lib.mkForce ''
          iptables -P INPUT DROP
          iptables -P FORWARD DROP
          iptables -P OUTPUT DROP
        '';
      };
    };

    # Disable Bluetooth functionality.
    hardware.bluetooth.enable = lib.mkForce false;
  };
}
