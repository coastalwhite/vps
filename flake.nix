{
  description = "A flake that defines the setup for my Personal VPS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    gburghoorn_com = {
        url = "github:coastalwhite/gburghoorn.com";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, gburghoorn_com }: let 
        system = "x86_64-linux";
        lib = nixpkgs.lib;
    in {
        nixosConfigurations = {
            vps = lib.nixosSystem {
                inherit system;
                specialArgs = {
                    inherit gburghoorn_com;
                };
                modules = [
                    ./configuration.nix
                ];
            };
        };
    };
}
