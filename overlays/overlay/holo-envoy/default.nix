{ stdenv, fetchFromGitHub, npmToNix, nodejs }:

stdenv.mkDerivation rec {
  name = "holo-envoy";

  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "envoy";
    rev = "1ef187c4c3d7f6dcbf3cd7d029a78c0474d13a49";
    sha256 = "1i8q15k8fy0af8layb7amaz5iwpxdwfw1kwvdlq30yjs3vv6dfmd";
  };

  nativeBuildInputs = [ nodejs ];

  preConfigure = ''
    cp -Lr ${npmToNix { inherit src; }} node_modules
    chmod -R +w node_modules
    patchShebangs node_modules
  '';

  buildPhase = ''
    node_modules/typescript/bin/tsc -d
  '';

  installPhase = ''
    mkdir $out
    mv * $out
  '';
}
