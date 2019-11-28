{ runCommand, fetchurl }:

let
  src = fetchurl {
    url = "https://github.com/Holo-Host/holo-hosting-app/releases/download/v0.4.1-alpha1/holo-hosting-app.dna.json";
    name = "holo-hosting-app.dna.json";
    sha256 = "0yxky5g6lb84g4zffqsmahdffz1drq9dqywsvgbzqxilwhsgm2cj";
  };
in

runCommand "holo-hosting-app" {} ''
  install -D ${src} $out/${src.name}
''
