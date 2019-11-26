{ stdenv, fetchFromGitHub, nodejs, npmToNix }:

stdenv.mkDerivation rec {
  name = "holofuel-app";

  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "holofuel-app";
    rev = "92b738445647046c3e185e0df4ca11f7498a0c28";
    sha256 = "128xrz0a37y73rmhsilws8nsi3d01m2gmy3fz8z4wrhx3gx5xh7n";
  };

  nativeBuildInputs = [ nodejs ];

  preConfigure = ''
    cp -r ${npmToNix { inherit src; }} node_modules
    chmod -R +w node_modules
    chmod +x node_modules/.bin/webpack
    patchShebangs node_modules
  '';

  buildPhase = ''
    npm run build
  '';

  installPhase = ''
    mkdir $out
    mv * $out
  '';

}
