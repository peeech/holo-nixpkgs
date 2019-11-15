{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "servicelogger";
    rev = "05905b2ea2af61b8c9fe2000215fd403d2398857";
    sha256 = "0ksq5aqzz32g20n235h71cwpjl8j4ih28s103fl5chzk4yj3iac9";
  };
in

(callPackage src {}).servicelogger
