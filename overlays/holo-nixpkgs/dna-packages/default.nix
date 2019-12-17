final: previous:

with final;

let
  # Not all of these DNAs are used, but are available here for manual `nix-build -A ...`
  happ-example = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "happ-example";
    rev = "7bdc2731de39bd83712feeab60e82ce983bed0d6";
    sha256 = "1q6y05dpxyb63is7p9gb385r6ixccdjrbnh7ldvxzcgn5jnb8y0i";
  };

  happ-store = fetchFromGitHub {
    owner = "holochain";
    repo = "happ-store";
    rev = "1c54a210089f93b54f5678d9353edb90070784de";
    sha256 = "0plaz9dxsy44wq4jn5yw0aqpqlf3ga5ppbz5sq29h2cgl3x23m2k";
  };

  holo-hosting-app = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hosting-app";
    rev = "be1e30020744cf5317e0362a288bfdfbae93dcdc";
    sha256 = "0yjnn2iyvk5wf1rv76sqr4jxhss10zxsyf5kld99brgpv5gn16v8";
  };

  servicelogger = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "de10163bc9b17522a455852e1f36001f355496ff";
    sha256 = "1lvvcksibh0njj9fvl7bzvinc4vv5jkcmxsys5h3z5z5k5a9h64l";
  };

  holofuel = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.14.0-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "0149vz255gyn6qkjg516gvmwhz1w4q03hn3grm5nssryd6kgasw0";
  };
in

{
  inherit (callPackage happ-example {}) happ-example;

  inherit (callPackage happ-store {}) happ-store;

  inherit (callPackage holo-hosting-app {}) holo-hosting-app;

  inherit (callPackage servicelogger {}) servicelogger;

  holofuel = wrapDNA holofuel;
}
