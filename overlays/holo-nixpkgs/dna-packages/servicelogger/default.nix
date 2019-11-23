{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "42a920b9ebfb8832fc8a1362696dc7c6fa714185";
    sha256 = "0rqx14yi1qf7xjlwiyalc49ilywg2dw5knwlc6zq2kpinqnfwcc2";
  };
in

(callPackage src {}).servicelogger
