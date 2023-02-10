final: prev: {
  clean-emptydir = final.callPackage ./scripts/clean-emptydir.nix {};
  listgroups = final.callPackage ./scripts/listgroups.nix {};
  listpath = final.callPackage ./scripts/listpath.nix {};
}
