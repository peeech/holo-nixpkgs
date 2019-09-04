{ stdenv, fetchFromGitHub, nodejs, npmToNix }:

stdenv.mkDerivation rec {
  name = "holofuel-app";

  src = fetchFromGitHub {
    owner = "samrose";
    repo = "holofuel-app";
    rev = "9e2cb4c88964028ca765b30f97bf8f79a16ab17b";
    sha256 = "0xf920v0xl2mxqah8s98fh0y55ck1wzl6i5rma0l9hhxd0m1amkr";
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
