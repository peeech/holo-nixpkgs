{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "373af9e889a70594d07a4979b92821eca03e2ab5";
    sha256 = "1kb2nw7wrhbcchxz0y2gs6zsqvi4cy1l2sfn0mphx6p28rqmwacl";
  };
in

(callPackage src {}).servicelogger
