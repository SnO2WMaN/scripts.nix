{
  pkgs,
  lib ? pkgs.lib,
}:
pkgs.runCommand "check-treefmt" {
  buildInputs = with pkgs; [
    treefmt
    alejandra
    dprint
  ];
  src = lib.sources.sourceFilesBySuffices ../. [
    ".nix"
    ".toml"
  ];
}
''
  mkdir $out
  treefmt \
    --no-cache \
    --fail-on-change \
    --config-file $src/treefmt.toml \
    --tree-root $src \
    --verbose \
    -C $src
''
