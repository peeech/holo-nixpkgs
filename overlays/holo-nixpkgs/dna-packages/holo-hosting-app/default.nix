{ runCommand, fetchurl }:

let
  src = fetchurl {
    url = "https://github.com/Holo-Host/holo-hosting-app/releases/download/v0.4.0-alpha1/holo-hosting-app.dna.json";
    name = "holo-hosting-app.dna.json";
    sha256 = "1mpk85dzh5rw9mp3aa643a125xfn0q1vy3s1j7a3i8z86h0nnhg6";
  };
in

runCommand "holo-hosting-app" {} ''
  install -D ${src} $out/${src.name}
''
