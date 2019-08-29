{ stdenv, fetchFromGitHub, nodejs, npmToNix }:

stdenv.mkDerivation rec {
  name = "holo-cli";

  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "node-holo-cli";
    rev = "af60f4ff8ca56fb1c48866ab5ed30081bc9384d7";
    sha256 = "03m0d1s5ss762g0kh0qg9jrpgvdicwwikrk70h1gskzqzl0azamg";
  };

  nativeBuildInputs = [ nodejs ];

  preConfigure = ''
    cp -Lr ${npmToNix { inherit src; }} node_modules
    chmod -R +w node_modules
    patchShebangs node_modules
  '';

  buildPhase = ":";

  installPhase = ''
    mkdir $out
    mv * $out
  '';

  fixupPhase = ''
    patchShebangs $out
  '';
}
