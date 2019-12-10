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
    rev = "5b96b9e507a6000b99f2e2473722e94412901990";
    sha256 = "1if37bwlv32zdqxs0s6zb7bnymw4x6594aj694bhilbkkadg2wxj";
  };
in

{
  inherit (callPackage servicelogger {}) servicelogger;

  happ-store = wrapDNA happ-store;

  holofuel = wrapDNA holofuel;

  holo-hosting-app = wrapDNA holo-hosting-app;
}
