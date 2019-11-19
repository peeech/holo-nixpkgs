{ runCommand, fetchurl }:

let
  src = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.13.0-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "0z8y0i2qkvab9a9ibzis0pylswk2bhi0p641qdrc6r8257vxjnpy";
  };
in

runCommand "holofuel" {} ''
  install -D ${src} $out/${src.name}
''
