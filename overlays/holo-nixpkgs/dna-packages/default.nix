final: previous:

with final;

let
  # Not all of these DNAs are used, but are available here for manual `nix-build -A ...`
  happ-example = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "happ-example";
    rev = "69f086021af0180a8132f46f3d041884f9c43fd8";
    sha256 = "152gmg64j1kjkc1rhxbq087bcn2qic09wh9iyghxwfgw1mkywpid";
  };

  happ-store = fetchFromGitHub {
    owner = "holochain";
    repo = "happ-store";
    rev = "a3d26d6cf4c45e0d503aabd0fa5bbe7e6c6d6a74";
    sha256 = "02s6d20nr9iwb57v0sp0sbh5pkwyara12bkv24p1ch3cg9clsq0i";
  };

  holo-hosting-app = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hosting-app";
    rev = "a84a8de8955ce32471aa758021841ff02c1f8f99";
    sha256 = "03dbp8mh99v618p40vkwdgrzcwf6xwzqpfhjq0y3z4spnq280lk5";
  };

  hylo-holo-dnas = fetchFromGitHub {
    owner = "holochain";
    repo = "hylo-holo-dnas";
    rev = "4c649ff014676c976cc7181415ddefed25ff36ad";
    sha256 = "06v3q70ahr7m24janc2msb2jvb1mfy8xyri3k53khcwn0pkwdr8l";
  };

  servicelogger = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "3c9faef1212d5e692dc196348b229056ad1432ba";
    sha256 = "1k7zq285adcr5w0rj1rw71kyc2nrrzqggss2z54r5zfvzcah25ab";
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
