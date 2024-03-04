# VPS

This contains the flake that is responsible for my personal VPS setup including
my webserver.

## Setup

Follow all commands in the `install.sh`.

```
scp root@<IP>:/etc/nixos/hardware-configuration.nix .
nixos-rebuild switch --flake path:.#vps --target-host root@<IP>
```

## Update Website

```
nix flake lock --update-input gburghoorn_com
nixos-rebuild switch --flake path:.#vps --target-host root@<IP>
```