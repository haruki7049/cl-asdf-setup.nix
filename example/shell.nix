{
  lib,
  stdenv,
  mkShell,
  fetchurl,
  fetchFromGitLab,

  sbcl,
}:

let
  central-registry = stdenv.mkDerivation rec {
    name = "central-registry";
    dontUnpack = true;

    buildInputs = [
      (fetchFromGitLab {
        domain = "gitlab.common-lisp.net";
        repo = "alexandria";
        owner = "alexandria";
        rev = "8514d8e68ed0c733abf7f96f9e91b24912686dc4";
        hash = "sha256-vPHp/dXX24zUPF1t7EdBryzqlG33A0fOoD5loFOxAEs=";
      })
    ];

    installPhase = ''
      mkdir $out
      cp -r ${lib.strings.concatStringsSep " " (builtins.map (drv: "${drv}/*") buildInputs)} $out
    '';
  };
in

mkShell {
  packages = [
    sbcl
  ];

  CL_CENTRAL_REGISTRY = "/nix/store/ai8djd2nbjjqyhzzcfxg2f5abqq7jfp2-central-registry";
}
