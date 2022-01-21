{
  description = "Nix configuration for darwin";

  inputs = {
    # Package sets
    # nixpkgs.url = "github:NixOS/nixpkgs/22.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/master";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    let system = "aarch64-darwin";
    in let pkgs = (import nixpkgs { inherit system; });
    in {
      darwinConfigurations = {
        nixpkgs = pkgs;
        macmini = darwin.lib.darwinSystem {
          system = system;
          modules = [
            ./system/darwin
            home-manager.darwinModules.home-manager
            {
              users.users.daniel.home = "/Users/daniel";

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";

                users.daniel = import ./home {
                  homeDirectory = "/Users/daniel";
                  nixpkgs = pkgs;
                  home-manager = home-manager;
                };
              };
            }
            ({ config, pkgs, lib, ... }: {
              services.nix-daemon.enable = true;
              nixpkgs = { config.allowBroken = true; };
            })
          ];
        };
      };
    };
}
