{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    {
      overlays.default = import ./overlay.nix;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = with inputs; [
            devshell.overlay
            self.overlays.default
          ];
        };
        inherit (flake-utils.lib) mkApp flattenTree;
      in {
        devShells.default = pkgs.devshell.mkShell {
          packages = with pkgs; [
            act
            alejandra
            taplo-cli
            treefmt
          ];
        };
        packages = flattenTree {
          inherit (pkgs) clean-emptydir listgroups listpath;
        };
        apps = with (self.packages.${system}); {
          clean-emptydir = mkApp {drv = clean-emptydir;};
          listgroups = mkApp {drv = listgroups;};
          listpath = mkApp {drv = listpath;};
        };
        checks = self.packages.${system};
      }
    );
}
