{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    devshell,
    ...
  }:
    {
      overlays.default = import ./overlay.nix;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            devshell.overlay
            self.overlays.default
          ];
        };
      in {
        devShells.default = pkgs.devshell.mkShell {
          imports = [(pkgs.devshell.importTOML ./devshell.toml)];
        };
        packages = import ./scripts.nix (name: pkgs.${name});
        apps = import ./scripts.nix (name: (flake-utils.lib.mkApp {drv = self.packages.${system}.${name};}));
        checks = import ./scripts.nix (name: (self.packages.${system}.${name}));
      }
    );
}
