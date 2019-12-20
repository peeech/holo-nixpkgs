final: previous:

with final;

let
  # Not all of these DNAs are used, but are available here for manual `nix-build -A ...`
  happ-example = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "happ-example";
    rev = "ddcfae9a160f0a7297e7e3d571eedec7e24a4ff6";
    sha256 = "0y0f8jysj8lfnd93lkjb1y4cwxl09klfyxcx2ywcqqpsm1nxg5sm";
  };

  happ-store = fetchFromGitHub {
    owner = "holochain";
    repo = "happ-store";
    rev = "4c2ce2e7f2e4801e12daa5799200dcd4a8ee0f76";
    sha256 = "1qv14yijcpx44f2k4xndqbs6y5qsz5ismzbh38h3i920dqlf7vsf";
  };

  holo-communities-dna = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-communities-dna";
    rev = "5844e19bf70d9df80cc0c8fceae084eb62168561";
    sha256 = "0hay631mrddnjvswa9f3i8py1z7zk9pxwrs8ghch3kgyk2pyh3fn";
  };

  holo-hosting-app = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hosting-app";
    rev = "7c0ff3a338f8ebd9d41755debdf28c607378059d";
    sha256 = "0ksil9rsd6yrlizxilimy0zi9ajgwhkng5m0zdkazgpp1762qim9";
  };

  holofuel = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.14.0-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "0149vz255gyn6qkjg516gvmwhz1w4q03hn3grm5nssryd6kgasw0";
  };

  servicelogger = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "31395d5fc1a01e1ec6107941defcdc265fb9f4da";
    sha256 = "1cb41kjknijj8ggmfpgf0dj4ki6s8vmlylb7b7775lj06jsdcnf6";
  };
in

{
  inherit (callPackage happ-example {}) happ-example;

  inherit (callPackage happ-store {}) happ-store;

  inherit (callPackage holo-communities-dna {}) holo-communities-dna;

  inherit (callPackage holo-hosting-app {}) holo-hosting-app;

  holofuel = wrapDNA holofuel;

  inherit (callPackage servicelogger {}) servicelogger;
}
