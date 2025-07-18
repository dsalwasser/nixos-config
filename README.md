# NixOS and Home-Manager Configuration

This repository contains my personal [NixOS](https://nixos.org/) and [Home-Manager](https://nix-community.github.io/home-manager/) configuration. My whole system and user profile is defined under a common [flake.nix](./flake.nix). This allows me to update my system with the following command.

```shell
sudo nixos-rebuild switch --flake github:dsalwasser/nixos-config
```

## How to Install and Use

To set up an installation of NixOS, refer to the [installation guide](INSTALL.md). Once you have NixOS installed and running, change into the directory that contains this configuration. Then, you can update your flake and rebuild your system by running `nix flake update` followed by `sudo nixos-rebuild switch --flake .#<target>`. Replace `<target>` with your desired system target (for example, `lenovo`). This will update and apply your system configuration.

## License

This project is licensed under the [MIT license](LICENSE).
