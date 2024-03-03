{
  description = "A flake that defines the setup for my Personal VPS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs }: let 
        system = "x86_64-linux";
        lib = nixpkgs.lib;
    in {
        nixosConfigurations = {
            vps = lib.nixosSystem {
                inherit system;
                specialArgs = {};
                modules = [
                    ./configuration.nix
                ];
            };
        };
    };
}
