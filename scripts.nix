mkValue:
builtins.listToAttrs (
  map (name: {
    name = name;
    value = mkValue name;
  }) [
    "clean-emptydir"
    "listgroups"
    "listpath"
  ]
)
