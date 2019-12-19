final: previous:

with final;

let
  # Not all of these DNAs are used, but are available here for manual `nix-build -A ...`
  happ-example = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "happ-example";
    rev = "702c75540eda33637f0a66a0a85413977a9e0e29";
    sha256 = "0izpwfknn4g9jx9r9686nhwj5v5wdg0s7hn4qrm3lpwdh89sgg7k";
  };

  happ-store = fetchFromGitHub {
    owner = "holochain";
    repo = "happ-store";
    rev = "ea424725f4ae4be51d40e4d34264c1b331fbf40f";
    sha256 = "19znqa6n56kpbgdw5dkkdj98h5v02j1dlry2iqcblkpmldavq7f1";
  };

  holo-communities-dna = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-communities-dna";
    rev = "3452a0f2fcc70e8e5f220577b6aa9dcc0c864b8e";
    sha256 = "1qa9q17aab3h0k4npjkrph4j0wvx05dxkfjrc8bfy4z8ljgfd4pa";
  };

  holo-hosting-app = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hosting-app";
    rev = "e23cadc68dda3ba05dcb94c263ec5327cdd7381b";
    sha256 = "02h5sf9wj6sbin6k46mzrrmdxj8m2izn9xr0i56li8ljpmm2prs7";
  };

  holofuel = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.14.0-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "0149vz255gyn6qkjg516gvmwhz1w4q03hn3grm5nssryd6kgasw0";
  };

  servicelogger = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "b9d447d8b5c600f4dbf367493572e128556cb49f";
    sha256 = "050zpkbc5z94ddz28s5j2bj18k2jsv06g3b37krmgn3gabk04frf";
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
