{
  lib,
  stdenv,
  replaceVars,
}:

{
  name,
  pname,
  version,
  buildInputs,
  lispImpls,
}:

stdenv.mkDerivation rec {
  name = if name != null then
    name
  else
    "${pname}-${version}";

  builderScript = replaceVars ./builder.lisp {
    pname = if name != null then name else pname;
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

  CL_SOURCE_REGISTRY = "${lib.strings.concatStringsSep "\n" (builtins.map (drv: "${drv}") buildInputs)}:${src}";
}
