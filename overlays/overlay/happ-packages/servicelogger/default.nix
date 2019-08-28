{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "servicelogger";
    rev = "18c3c7b4b0d0a307c239c1aa1d9e2d8ba49566a5";
    sha256 = "0bb8i1rh943hhw4w0qz7gkhhjaw995b0n1j1bp4i4s31pr5nw2m7";
  };
in

(callPackage src {}).servicelogger
