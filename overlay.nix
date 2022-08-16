final: prev: (
  import ./scripts.nix (name: final.callPackage (import ./scripts/${name}.nix) {})
)
