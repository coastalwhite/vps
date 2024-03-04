{
    config,
    pkgs,
    lib,
    gburghoorn_com,
    ...
}:

let
    basedrive = "/dev/vda";
    system = "x86_64-linux";
    domain = "gburghoorn.com";
in {
    imports = [
      ./hardware-configuration.nix
    ];
    
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = basedrive;

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = false;
        };
    };

    users.users = {
        root = {
            password = "pw123";
            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuxKJCMup6I1t3QYBu1nUhIa1A2/zw8m3wrUFLNLpYn"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDg0iUGVVFPsP9NDU4hVY8NdP+HCokXmFxNyIZCxXo7s"
            ];
        };
    };

    services.nginx = {
        enable = true;

        virtualHosts."${domain}" = {
            enableACME = true;
            forceSSL = true;
            serverName = domain;
            root = "${gburghoorn_com.packages.${system}.default}";
        };

		recommendedTlsSettings = true;
		recommendedGzipSettings = true;
		recommendedOptimisation = true;
    };

    security.acme.acceptTerms = true;
    security.acme.certs = {
        "${domain}".email = "me@gburghoorn.com";
    };

    networking.firewall.allowedTCPPorts = [ 22 80 443 ];

	system.stateVersion = "23.11";
}