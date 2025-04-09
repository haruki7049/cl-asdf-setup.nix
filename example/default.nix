# Run `nix-build -E 'with import <nixpkgs> { overlays = [ (import ../.) ]; }; callPackage ./. { }'`

{
  lib,
  callPackage,
  fetchzip,
  fetchFromGitLab,
  fetchFromGitHub,
  lispDerivation ? callPackage ../nix/lispDerivation { },

  sbcl,
  clisp,
  ecl,
}:

let
  alexandria = lispDerivation {
    name = "alexandria";
    src = fetchFromGitLab {
      domain = "gitlab.common-lisp.net";
      repo = "alexandria";
      owner = "alexandria";
      rev = "8514d8e68ed0c733abf7f96f9e91b24912686dc4";
      hash = "sha256-vPHp/dXX24zUPF1t7EdBryzqlG33A0fOoD5loFOxAEs=";
    };

    lisps = [
      sbcl
    ];

    doCheck = true;

    runner = sbcl;
  };

  asdf-flv = lispDerivation {
    name = "net.didierverna.asdf-flv";
    src = fetchFromGitHub {
      owner = "didierverna";
      repo = "asdf-flv";
      rev = "3f1de416f7f40a39c47f08335c710a884ece36b3";
      hash = "sha256-XKMv04SNF7brzLReTSe9GJBaLJITDYUPyF41TRuUbOs=";
    };

    lisps = [
      sbcl
      ecl
      clisp
    ];

    doCheck = true;

    runner = sbcl;
  };

  trivial-backtrace = lispDerivation {
    name = "trivial-backtrace";
    src = fetchFromGitHub {
      owner = "hraban";
      repo = "trivial-backtrace";
      rev = "7f90b4a4144775cca0728791e4b92ac2557b07a1";
      hash = "sha256-dg5xWOdR1NuRjgJq6KBwbrNxS2ZKH94JwsXa+va4QIY=";
    };

    lisps = [
      sbcl
      clisp
      ecl
    ];

    runner = sbcl;

    dontCheck = true;
  };
in

lispDerivation {
  pname = "fiveam";
  version = "dev";
  src = lib.cleanSource ./.;

  lispLibs = [
    alexandria
    asdf-flv
    trivial-backtrace
  ];

  lisps = [
    sbcl
    clisp
    ecl
  ];

  runner = sbcl;
}
