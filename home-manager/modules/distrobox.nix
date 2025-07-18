{ config, ... }: {
  programs.distrobox = {
    enable = true;

    containers = {
      archlinux = {
        image = "archlinux:latest";
        home = "${config.home.homeDirectory}/Shared/archlinux";
        unshare_all = true;
      };

      debian = {
        image = "debian:bookworm";
        home = "${config.home.homeDirectory}/Shared/debian";
        unshare_all = true;
      };

      fedora = {
        image = "fedora:42";
        home = "${config.home.homeDirectory}/Shared/fedora";
        unshare_all = true;
      };

      rhel = {
        image = "almalinux:9";
        home = "${config.home.homeDirectory}/Shared/rhel";
        unshare_all = true;
      };
    };
  };
}
