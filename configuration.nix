{
    config,
    pkgs,
    lib,
    ...
}:

let
    domain = "localhost";
in {
    imports = [
      ./hardware-configuration.nix
    ];
    
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/vda";

    services.openssh = {
        enable = true;
        passwordAuthentication = false;
    };

    users.users = {
        root = {
            password = "password123";
            openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuxKJCMup6I1t3QYBu1nUhIa1A2/zw8m3wrUFLNLpYn" ];
        };
    };

    services.nginx = {
        enable = true;

        virtualHosts."${domain}" = {
            enableACME = true;
            forceSSL = true;
            serverName = domain;
            root = "/var/www/home";
        };
    };

    security.acme.acceptTerms = true;
    security.acme.certs = {
        "${domain}".email = "me@gburghoorn.com";
    };

    networking.firewall.allowedTCPPorts = [ 22 80 443 ];

	system.stateVersion = "23.11";
}