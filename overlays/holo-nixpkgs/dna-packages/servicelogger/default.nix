{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "servicelogger";
    rev = "28976169ed87c4eff57467ab418ef6949eee7eaa";
    sha256 = "1gmivrkc1m91vqrizi8ykzncv1ghjc7xxprw5j0qy9gz43x3xh2w";
  };
in

(callPackage src {}).servicelogger
