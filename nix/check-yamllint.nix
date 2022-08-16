{
  pkgs,
  lib ? pkgs.lib,
}:
pkgs.runCommand "check-yamllint" {
  buildInputs = with pkgs; [yamllint];
  src = lib.sources.sourceFilesBySuffices ./. [".yml" ".yaml"];
}
''
  mkdir $out
  yamllint --strict $src
''
