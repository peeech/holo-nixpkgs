{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "happ-example";
    rev = "086f349d524bb020b5cd11097a2bc393986f141d";
    sha256 = "09x0p7ysbw077cgnmv50mllzdh3b9930klqqjh9lpmq82ss0liak";
  };
in

(callPackage src {}).happ-example
