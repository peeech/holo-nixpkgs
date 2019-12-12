final: previous:

with final;

let
  happ-store = fetchurl {
    url = "https://github.com/holochain/happ-store/releases/download/v0.4.1-alpha1/hApp-store.dna.json";
    name = "happ-store.dna.json";
    sha256 = "1y89q052y6nbm70akdb2qfbkc7yj73xla4qjw2lmk0b76g06l0r8";
  };

  holofuel = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.13.1-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "10xmq52m37r09flmsri64iwrpi9l88s9zmdl50l346ld6rxd0jf8";
  };

  holo-hosting-app = fetchurl {
    url = "https://github.com/Holo-Host/holo-hosting-app/releases/download/v0.4.1-alpha1/holo-hosting-app.dna.json";
    name = "holo-hosting-app.dna.json";
    sha256 = "0yxky5g6lb84g4zffqsmahdffz1drq9dqywsvgbzqxilwhsgm2cj";
  };

  servicelogger = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "3b716c325e4243f5c88e2f65530cd6495a9f4ae5";
    sha256 = "03izll3b5ajgbw9b6df7vxc68ysxd4xzbrw2p41r9ybgmnn9bii8";
  };
in

{
  inherit (callPackage servicelogger {}) servicelogger;

  happ-store = wrapDNA happ-store;

  holofuel = wrapDNA holofuel;

  holo-hosting-app = wrapDNA holo-hosting-app;
}
