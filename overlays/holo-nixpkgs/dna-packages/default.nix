final: previous:

with final;

let
  happ-store = fetchFromGitHub {
    owner = "holochain";
    repo = "happ-store";
    rev = "4e27b888810b45d706b2982f7d97aa454aaf74cf";
    sha256 = "18h0x2m5vnmm1xz5k0j7rsc4il62vhq29qcl7wn1f9vmsfac2lrv";
  };

  holofuel = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.13.1-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "10xmq52m37r09flmsri64iwrpi9l88s9zmdl50l346ld6rxd0jf8";
  };

  holo-hosting-app = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hosting-app";
    rev = "bbda39876d5bc206712fcbe27fdb5e405006e539";
    sha256 = "0wf7133cam8s3m6hww5fk29343z2a0xf2qv764radx5pcr02lhs0";
  };

  servicelogger = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "de10163bc9b17522a455852e1f36001f355496ff";
    sha256 = "1lvvcksibh0njj9fvl7bzvinc4vv5jkcmxsys5h3z5z5k5a9h64l";
  };
in

{
  inherit (callPackage happ-store {}) happ-store;

  inherit (callPackage holo-hosting-app {}) holo-hosting-app;

  inherit (callPackage servicelogger {}) servicelogger;

  holofuel = wrapDNA holofuel;
}
