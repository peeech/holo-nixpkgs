{ callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "holo-host";
    repo = "happ-example";
    rev = "ef7bb20af2122f8f0920d844109f93bf635b2307";
    sha256 = "1mmhf0ha7gcbmzg4as2nsc4d2k7qk5vywp7rppcmwwzdr5a473hz";
  };
in

(callPackage src {}).happ-example
