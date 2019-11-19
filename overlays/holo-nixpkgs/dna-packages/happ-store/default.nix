{ runCommand, fetchurl }:

let
  src = fetchurl {
    url = "https://github.com/holochain/happ-store/releases/download/v0.4.0-alpha1/hApp-store.dna.json";
    name = "happ-store.dna.json";
    sha256 = "07f1dkwmy2shklch858s1ia98cw1vdhsf4cbfnn7488zwbjj198z";
  };
in

runCommand "happ-store" {} ''
  install -D ${src} $out/${src.name}
''
