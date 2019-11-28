{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "happ-example";
    rev = "74a2d789502be44b86e21e5eb5566bce36e62f5c";
    sha256 = "0x4jym0bfh7m55kavjphq0b166f1f183b17ld0lldk5aczdan5sn";
  };
in

(callPackage src {}).happ-example
