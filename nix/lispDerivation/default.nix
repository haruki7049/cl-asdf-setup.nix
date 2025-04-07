{
  lib,
  stdenv,
  replaceVars,
}:

{
  name ? null,
  pname,
  version ? null,
  src,
  buildInputs ? [],
  lispImpls,
}@args:

stdenv.mkDerivation rec {
  name = args.name or "${args.pname}-${args.version}";
  inherit (args) src;

  builderScript = replaceVars ./builder.lisp {
    pname = args.name or args.pname;
  };

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR

    ${lib.strings.concatStringsSep "\n" (
      builtins.map (drv: "cat '${builderScript}' | ${lib.getExe drv}") lispImpls
    )}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r * $out

    runHook postInstall
  '';

  CL_SOURCE_REGISTRY = "${lib.strings.concatStringsSep ":" (builtins.map (drv: "${drv}") args.buildInputs)}:${args.src}";
}
