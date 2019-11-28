{ runCommand, fetchurl }:

let
  src = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.13.1-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "10xmq52m37r09flmsri64iwrpi9l88s9zmdl50l346ld6rxd0jf8";
  };
in

runCommand "holofuel" {} ''
  install -D ${src} $out/${src.name}
''
