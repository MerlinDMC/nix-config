{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs, ... }:
  let system = "aarch64-darwin";
  in let pkgs = (import nixpkgs { inherit system; });
  in
  {
    darwinConfigurations = {
      "bootstrap" = nix-darwin.lib.darwinSystem {
        system = system;
        modules = [
          # configuration
          ./system/darwin
        ];
      };

      "VM" = nix-darwin.lib.darwinSystem {
        system = system;
        modules = [
          # configuration
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
        ];
      };

      "b7b7b16d-8ad0-5f2c-9e27-f96b3acf8534" = nix-darwin.lib.darwinSystem {
        system = system;
        modules = [
          # configuration
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
        ];
      };
    };
  };
}
