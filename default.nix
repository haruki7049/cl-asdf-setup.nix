final: prev: {
  lispDerivation = prev.callPackage ./nix/lispDerivation { };
  makeCommonLispSourceRegistry = prev.callPackage ./nix/makeCommonLispSourceRegistry { };
}
