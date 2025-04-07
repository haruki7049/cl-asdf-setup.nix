{
  lib,
  stdenv,
  fetchzip,
  fetchFromGitHub,
  fetchFromGitLab,
  replaceVars,

  sbcl,
  clisp,
}:

let
  alexandria = fetchFromGitLab {
    domain = "gitlab.common-lisp.net";
    repo = "alexandria";
    owner = "alexandria";
    rev = "8514d8e68ed0c733abf7f96f9e91b24912686dc4";
    hash = "sha256-vPHp/dXX24zUPF1t7EdBryzqlG33A0fOoD5loFOxAEs=";
  };

  asdf-flv = fetchFromGitHub {
    repo = "asdf-flv";
    owner = "didierverna";
    rev = "3f1de416f7f40a39c47f08335c710a884ece36b3";
    hash = "sha256-XKMv04SNF7brzLReTSe9GJBaLJITDYUPyF41TRuUbOs=";
  };

  trivial-backtrace = fetchzip {
    url = "http://common-lisp.net/project/trivial-backtrace/trivial-backtrace.tar.gz";
    hash = "sha256-0enXFClfULa7iPagwD9x5ueaJPBcLURp1vuhGMyPZUs=";
  };
in

stdenv.mkDerivation rec {
  pname = "fiveam";
  version = "dev";
  src = lib.cleanSource ./.;

  builderScript = replaceVars ./builder.lisp {
    inherit pname;
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

  CL_SOURCE_REGISTRY = "${alexandria}:${asdf-flv}:${trivial-backtrace}:${src}";

  lispImpls = [
    sbcl
    clisp
  ];
}
