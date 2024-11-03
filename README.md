# NixOS and Home-Manager Configuration

This repository contains my personal [NixOS](https://nixos.org/) and
[Home-Manager](https://nix-community.github.io/home-manager/) configuration. My
whole system and user profile is defined under a common [flake.nix](./flake.nix).
This allows me to update my system targeting with the following command.

```sh
sudo nixos-rebuild switch --flake github:dsalwasser/nixos-config
```

## How to Install and Use

To set up an installation of NixOS refer to the [installation guide](INSTALL.md).
If you have NixOS booted up, use `sudo nixos-rebuild switch --flake .#nixos`
to rebuild your system.

## License

This project is licensed under the [MIT license](./LICENSE).
