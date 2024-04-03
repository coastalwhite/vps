{
  description = "A flake that defines the setup for my Personal VPS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    gburghoorn_com = {
        url = "github:coastalwhite/gburghoorn.com";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    wavedrom_rs = {
        url = "github:coastalwhite/wavedrom-rs";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, gburghoorn_com, wavedrom_rs }: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = nixpkgs.lib;
    in rec {
      packages.${system}.www = pkgs.runCommand "www" {} ''
        mkdir -p $out
        mkdir -p $out/wavedrom

        cp -r ${gburghoorn_com.packages.${system}.default}/* $out/
        cp -r ${wavedrom_rs.packages.${system}.editor}/*     $out/wavedrom
      '';

      nixosConfigurations.vps = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit (packages.${system}) www; };
        modules = [
          ./configuration.nix
        ];
      };
    };
}
