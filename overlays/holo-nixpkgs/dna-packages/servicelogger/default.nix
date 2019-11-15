{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "servicelogger";
    rev = "85c8c9cdc1be41ea2f401ee077d9b4e515225f59";
    sha256 = "10xvifj1hm576ybfbhxb51nshflrhs4qyl8sf3s7gqhc81cp5d94";
  };
in

(callPackage src {}).servicelogger
