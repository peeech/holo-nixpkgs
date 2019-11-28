{ runCommand, fetchurl }:

let
  src = fetchurl {
    url = "https://github.com/holochain/happ-store/releases/download/v0.4.1-alpha1/hApp-store.dna.json";
    name = "happ-store.dna.json";
    sha256 = "1y89q052y6nbm70akdb2qfbkc7yj73xla4qjw2lmk0b76g06l0r8";
  };
in

runCommand "happ-store" {} ''
  install -D ${src} $out/${src.name}
''
