{
  lib,
  mkShell,
  fetchzip,
  fetchFromGitHub,
  fetchFromGitLab,

  sbcl,
}:

let
  makeCommonLispSourceRegistry = drv-list: lib.strings.makeSearchPathOutput "" "" drv-list;

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

mkShell rec {
  packages = [
    sbcl
  ];

  buildInputs = [
    alexandria
    asdf-flv
    trivial-backtrace
  ];

  CL_SOURCE_REGISTRY = makeCommonLispSourceRegistry buildInputs;
}
