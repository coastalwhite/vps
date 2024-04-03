# VPS

This contains the flake that is responsible for my personal VPS setup including
my webserver.

## Setup

Follow all commands in the `install.sh`.

```bash
scp root@<IP>:/etc/nixos/hardware-configuration.nix .
nixos-rebuild switch --flake path:.#vps --target-host root@<IP>
```

## Update Website

```bash
nix flake lock --update-input gburghoorn_com
nixos-rebuild switch --flake path:.#vps --target-host root@<IP>
```

## View website statistics

```bash
ssh root@<IP>
nix-shell -p goaccess
goaccess /var/log/nginx/access.log -o report.html --log-format=COMBINED
exit
scp root@<IP>:/root/report.html .
chromium report.html
```