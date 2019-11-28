{ stdenv
, fetchurl
, fetchgit
, runCommand
, writeTextFile
, darwin
, nodejs
, python2
, utillinux
, autoconf
, automake
, libtool
}:

let
  nodeEnv = import ./node-env.nix {
    inherit stdenv runCommand writeTextFile nodejs python2 utillinux;
    libtool = darwin.cctools;
  };

  globalBuildInputs = stdenv.lib.attrValues (
    import ./supplement.nix {
      inherit nodeEnv fetchurl fetchgit;
    }
  );

  # node2nix --nodejs10 -l package-lock.json --supplement-input supplement.json
  nodePackages = import ./node-packages.nix {
    inherit globalBuildInputs nodeEnv fetchurl fetchgit;
  };
in

nodePackages.package.overrideAttrs (
  super: {
    nativeBuildInputs = (super.nativeBuildInputs or []) ++ [
      autoconf
      automake
    ];

    buildInputs = (super.buildInputs or []) ++ [
      libtool
    ];
  }
)
