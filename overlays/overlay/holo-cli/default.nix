{ stdenv, fetchFromGitHub, gitignoreSource, nodejs, npmToNix }:

stdenv.mkDerivation rec {
  name = "holo-cli";

  # To reference a local checkout:
  #src =  gitignoreSource ../../../../node-holo-cli;
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "node-holo-cli";
    rev = "653dca686e60af480318635450bb1b092d75f6a2";
    sha256 = "15yafq4g5w0lpl3pmqvplyjdwr7rb3dj0g5gv3zd1w9r0bbw3g0n";
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
