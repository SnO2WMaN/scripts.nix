{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # dev
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    devshell.url = "github:numtide/devshell";
    treefmt-upstream.url = "github:numtide/treefmt";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    devshell,
    treefmt-upstream,
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
            (_: _: {treefmt = treefmt-upstream.packages.${system}.treefmt;})
          ];
        };
        inherit (pkgs) lib;
      in {
        devShells.default = pkgs.devshell.mkShell {
          imports = [(pkgs.devshell.importTOML ./devshell.toml)];
        };
        packages = import ./scripts.nix (name: (pkgs.${name}));
        apps = import ./scripts.nix (name: (flake-utils.lib.mkApp {drv = self.packages.${system}.${name};}));
        checks = import ./scripts.nix (name: (self.packages.${system}.${name}));
      }
    );
}
