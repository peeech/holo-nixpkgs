final: previous:

with final;

let
  # Not all of these DNAs are used, but are available here for manual `nix-build -A ...`
  happ-example = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "happ-example";
    rev = "d59256a67ab1208b7597c7a3a4871b041b2f3d5c";
    sha256 = "0a91jncsva9fxs23qwkil6bpcsq376h9vy675ksa9im8xc52k7l0";
  };

  happ-store = fetchFromGitHub {
    owner = "holochain";
    repo = "happ-store";
    rev = "fe06d08f014d1d01d18f0d48f465d177b4491bc2";
    sha256 = "1m3d9wsyrcs5rwhl7s20shxrz6zz6m39bsmv3l7h5jnjamxamlj7";
  };

  holo-hosting-app = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hosting-app";
    rev = "7c1715537440fd9284f84d5337e0b8d56c690e0e";
    sha256 = "13vpf29c631gzxa0n1mmby1cpxrimv4f02dps11s7ia9lzcx854q";
  };

  hylo-holo-dnas = fetchFromGitHub {
    owner = "holochain";
    repo = "hylo-holo-dnas";
    rev = "675a563204af6bc72fd3e2351e8f12bce23e7073";
    sha256 = "1hbywvgm69hxjzkpaxx6lj2anvjqp04y00b4iz4fb8bag7sa80kx";
  };

  hylo-holo-dnas = fetchFromGitHub {
    owner = "holochain";
    repo = "hylo-holo-dnas";
    rev = "b1d07d4669a7c0e317de2cf0034960fc094e19b1";
    sha256 = "1hn1x16a7lxrp879vxg8imd5l7kkvg1pdqb9fr1v2jjcfdx7j943";
  };

  servicelogger = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "5417eb8e44f52bea9a56f8261af8d060d0ea7f97";
    sha256 = "0wyym97bv6a6va9whgpk3b63vm95iv3hrx1yil68iz2cwhn86nkq";
  };

  holofuel = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.14.0-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "0149vz255gyn6qkjg516gvmwhz1w4q03hn3grm5nssryd6kgasw0";
  };
in

{
  inherit (callPackage happ-example {}) happ-example;

  inherit (callPackage happ-store {}) happ-store;

  inherit (callPackage holo-hosting-app {}) holo-hosting-app;

  inherit (callPackage hylo-holo-dnas {}) hylo-holo-dnas;

  inherit (callPackage servicelogger {}) servicelogger;

  holofuel = wrapDNA holofuel;
}
