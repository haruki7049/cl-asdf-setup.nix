{
  lib,
  stdenv,
  replaceVars,
}:

{
  name ? null,
  pname ? null,
  version ? null,
  src,
  lispLibs ? [ ],
  lisps,
  runner,
  ...
}@args:

stdenv.mkDerivation (
  args
  // rec {
    name = args.name or "${args.pname}-${args.version}";
    inherit (args) src;

    builderScript = replaceVars ./builder.lisp {
      pname = args.name or args.pname;
    };

    checkerScript = replaceVars ./checker.lisp {
      pname = args.name or args.pname;
    };

    checkPhase = ''
      runHook preCheck

      export HOME=$TMPDIR

      ${lib.strings.concatStringsSep "\n" (
        builtins.map (drv: "cat '${checkerScript}' | ${lib.getExe drv}") lisps
      )}

      runHook postCheck
    '';

    buildPhase = ''
      runHook preBuild

      export HOME=$TMPDIR

      ${lib.strings.concatStringsSep "\n" (
        builtins.map (drv: "cat '${builderScript}' | ${lib.getExe drv}") lisps
      )}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r * $out

      runHook postInstall
    '';

    CL_SOURCE_REGISTRY = "${lib.strings.concatStringsSep ":" (
      builtins.map (drv: "${drv.CL_SOURCE_REGISTRY}") args.lispLibs or [ ] ++ [ args.src ]
    )}";
  }
)
