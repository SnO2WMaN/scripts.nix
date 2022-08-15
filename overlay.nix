final: prev: (builtins.listToAttrs (
  map (
    name: {
      name = name;
      value = final.callPackage (import ./scripts/${name}.nix) {};
    }
  ) [
    "clean-emptydir"
    "listgroups"
    "listpath"
  ]
))
