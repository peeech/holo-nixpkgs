{ runCommand, fetchurl }:

let
  src = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/0.9.7-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "0cgl88izvj4gnjvv21j8fz0fax3l45gmf0iqnhd64qpdgsb2ihah";
  };
in

runCommand "holofuel" {} ''
  install -D ${src} $out/${src.name}
''
