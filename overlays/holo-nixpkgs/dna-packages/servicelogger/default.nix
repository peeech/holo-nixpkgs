{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "2add4457d8a62a388a0a9416f9535f0276a8a482";
    sha256 = "1jgsg8xwxxp5x48sw9drw7n5g910qqqg6k20m13ip4nc960qrc7k";
  };
in

(callPackage src {}).servicelogger
