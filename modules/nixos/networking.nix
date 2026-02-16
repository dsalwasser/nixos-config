{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.components.networking;
in {
  options.components.networking = {
    enable = lib.mkEnableOption "Whether to enable the networking subsystem.";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      # Configure devices to obtain IP addresses via DHCP.
      useDHCP = lib.mkDefault true;

      # Make sure that the firewall is enabled and use nftables as the backend.
      firewall.enable = lib.mkForce true;
      nftables.enable = true;

      # Use NetworkManager for configuring network devices.
      networkmanager = {
        enable = true;
        plugins = [pkgs.networkmanager-openvpn];
      };
    };

    # Enable encrypted DNS.
    services.dnscrypt-proxy = {
      enable = true;
      settings = {
        # Server must support DNS security extensions (DNSSEC).
        require_dnssec = true;

        # Server must not log user queries (declarative).
        require_nolog = true;

        # Server must not enforce its own blocklist.
        require_nofilter = true;

        # Path to the query log file. Helpful to check if dnscrypt-proxy is actually used.
        query_log.file = "/var/log/dnscrypt-proxy/query.log";

        # Remote lists of DNS resolvers supporting the DNSCrypt and DNS-over-HTTP2 protocols.
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
      };
    };
  };
}
