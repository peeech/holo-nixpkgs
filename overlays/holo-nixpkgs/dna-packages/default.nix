final: previous:

with final;

let
  # Not all of these DNAs are used, but are available here for manual `nix-build -A ...`
  happ-example = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "happ-example";
    rev = "3d8ec4f4929565ee5279a595d6a7604db58e48a0";
    sha256 = "0g9ckzfyd5r2jngiw0jpnwx2iyimlmaaw93433718l79887qnxy7";
  };

  happ-store = fetchFromGitHub {
    owner = "holochain";
    repo = "happ-store";
    rev = "17b53e29d6fcf48540b2e16864233b72acd59233";
    sha256 = "1i0b7y5f3c8rc74lyjkyjkknaima8bcs0iy6z31b26zpjgiagz13";
  };

  holo-communities-dna = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-communities-dna";
    rev = "a527dbcc3391a816f9bee3dcb48cfa11fd4d7d04";
    sha256 = "13zh96b3njyxsz4mf5417ra1vdv3yvapidh4gnb9hgszybknj30b";
  };

  holo-hosting-app = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-hosting-app";
    rev = "e2866abc4e958cbf565ce1bff6e716123c559f87";
    sha256 = "0gsjslnwf7i42r4dyx0b05v3ff1z6svdgcb9d5cvnsxslhz86wvv";
  };

  holofuel = fetchurl {
    url = "https://holo-host.github.io/holofuel/releases/download/v0.14.0-alpha1/holofuel.dna.json";
    name = "holofuel.dna.json";
    sha256 = "0149vz255gyn6qkjg516gvmwhz1w4q03hn3grm5nssryd6kgasw0";
  };

  servicelogger = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "servicelogger";
    rev = "5865a39b0d040e12b9fc5db43bfe3941991eed1f";
    sha256 = "1wmmppfrhm46an3n924bkq5gnc955wbrikl6bgaj2n24wdmggrsb";
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
