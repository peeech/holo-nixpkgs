final: previous:

with final;
with lib;

let
  cargo-to-nix = fetchFromGitHub {
    owner = "transumption-unstable";
    repo = "cargo-to-nix";
    rev = "ba6adc0a075dfac2234e851b0d4c2511399f2ef0";
    sha256 = "1rcwpaj64fwz1mwvh9ir04a30ssg35ni41ijv9bq942pskagf1gl";
  };

  gitignore = fetchFromGitHub {
    owner = "hercules-ci";
    repo = "gitignore";
    rev = "f9e996052b5af4032fe6150bba4a6fe4f7b9d698";
    sha256 = "0jrh5ghisaqdd0vldbywags20m2cxpkbbk5jjjmwaw0gr8nhsafv";
  };

  holo-config = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "holo-config";
    rev = "a7fae5926f2c8b6bb26111863873dc3ca55b2b6c";
    sha256 = "1lcvnb93ayb593xgyd8ylwaldmh1s2vp28g7ydgmh598y81ljp57";
  };

  hpstatus = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "hpstatus";
    rev = "005435217305f76f3d51722f462f310a2baeab11";
    sha256 = "1gszq98xdvq515g2kaxan886p4cgmwgqmb0g7b9a66m5087p3jg4";
  };

  holo-envoy = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "envoy";
    rev = "52b0b34907474ef39f123c855ed6caae89b63396";
    sha256 = "0648bmv33cmb53ppn3ph44v52yx19qd6nnjskgmkyk05xmgd391y";
  };

  holochain-rust = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain-rust";
    rev = "0e9737e4201d9bc2df5a77962c0430f757b2bbe4";
    sha256 = "1559gssay69d9qfiap24m5r728xxq72kk56l9xhg2majwzmk6fxx";
  };

  holochainRust = callPackage holochain-rust {};

  nixpkgs-mozilla = fetchTarball {
    url = "https://github.com/mozilla/nixpkgs-mozilla/archive/dea7b9908e150a08541680462fe9540f39f2bceb.tar.gz";
    sha256 = "0kvwbnwxbqhc3c3hn121c897m89d9wy02s8xcnrvqk9c96fj83qw";
  };

  npm-to-nix = fetchFromGitHub {
    owner = "transumption-unstable";
    repo = "npm-to-nix";
    rev = "6d2cbbc9d58566513019ae176bab7c2aeb68efae";
    sha256 = "1wm9f2j8zckqbp1w7rqnbvr8wh6n072vyyzk69sa6756y24sni9a";
  };
in

{
  inherit (callPackage cargo-to-nix {}) buildRustPackage cargoToNix;
  inherit (callPackage gitignore {}) gitignoreSource;

  inherit (callPackage holo-config {})
    holo-config-derive
    holo-config-generate-cli
    holo-config-generate-web;

  inherit hpstatus;
  inherit (callPackage npm-to-nix {}) npmToNix;
  inherit (callPackage "${nixpkgs-mozilla}/package-set.nix" {}) rustChannelOf;

  buildDNA = makeOverridable (callPackage ./build-dna {
    inherit (llvmPackages_8) lld;
    inherit (rust.packages.nightly) rustPlatform;
  });

  buildHoloPortOS = hardware:
    buildImage [ holoportos.profile hardware ];

  buildImage = imports:
    let
      system = nixos {
        inherit imports;
      };

      imageNames = filter (name: hasAttr name system) [
        "isoImage"
        "sdImage"
        "virtualBoxOVA"
        "vm"
      ];
    in
    head (attrVals imageNames system);

  singletonDir = path:
    let
      drv = lib.toDerivation path;
    in
    runCommand "singleton" {} ''
      mkdir $out
      ln -s ${path} $out/${drv.name}
    '';

  tryDefault = x: default:
    let
      eval = builtins.tryEval x;
    in
    if eval.success then eval.value else default;

  writeJSON = config: writeText "config.json" (builtins.toJSON config);

  writeTOML = config: runCommand "config.toml" {} ''
    ${remarshal}/bin/json2toml < ${writeJSON config} > $out
  '';

  dnaHash = dna: builtins.readFile (runCommand "${dna.name}-hash" {} ''
    ${holochain-cli}/bin/hc hash -p ${dna}/${dna.name}.dna.json \
      | tail -1 \
      | cut -d ' ' -f 3- \
      | tr -d '\n' > $out
  '');

  dnaPackages = recurseIntoAttrs {
    happ-example = callPackage ./dna-packages/happ-example {};
    happ-store = callPackage ./dna-packages/happ-store {};
    holo-hosting-app = callPackage ./dna-packages/holo-hosting-app {};
    holofuel = callPackage ./dna-packages/holofuel {};
    servicelogger = callPackage ./dna-packages/servicelogger {};
  };

  aurora-led = callPackage ./aurora-led {};

  extlinux-conf-builder = callPackage ./extlinux-conf-builder {};

  inherit (callPackage holo-envoy {}) holo-envoy;
  inherit (holochainRust) holochain-cli holochain-conductor sim2h-server;

  hclient = callPackage ./hclient {};

  holofuel-app = callPackage ./holofuel-app {};

  holofuel-demo-configure = callPackage ./holofuel-demo-configure {};

  holoport-hardware-test = callPackage ./holoport-hardware-test {};

  holoport-nano-dtb = callPackage ./holoport-nano-dtb {
    linux = linux_latest;
  };

  holo-auth-client = callPackage ./holo-auth-client {
    stdenv = stdenvNoCC;
    python3 = python3.withPackages (ps: [ ps.requests ]);
  };

  holo-init = callPackage ./holo-init {
    stdenv = stdenvNoCC;
    python3 = python3.withPackages (ps: [ ps.requests ps.retry ]);
  };

  # TODO: upstream to holochain-cli
  holo-keygen = callPackage ./holo-keygen {
    stdenv = stdenvNoCC;
  };

  holo-nixpkgs-tests = recurseIntoAttrs (import ../../tests {
    inherit pkgs;
  });
 
  holoportos = recurseIntoAttrs {
    profile = tryDefault <nixos-config> ../../profiles/holoportos;

    qemu = (buildHoloPortOS ../../profiles/hardware/qemu) // {
      meta.platforms = [ "aarch64-linux" "x86_64-linux" ];
    };

    virtualbox = (buildHoloPortOS ../../profiles/hardware/virtualbox) // {
      meta.platforms = [ "x86_64-linux" ];
    };
  };

  holoportos-install = callPackage ./holoportos-install {};

  holoportos-led-daemon = callPackage ./holoportos-led-daemon {};

  hydra = previous.hydra.overrideAttrs (super: {
    doCheck = false;
    patches = [
      ./hydra/logo-vertical-align.diff
      ./hydra/no-restrict-eval.diff
    ];
    meta = super.meta // {
      hydraPlatforms = [ "x86_64-linux" ];
    };
  });

  libsodium = previous.libsodium.overrideAttrs (super: {
    # Separate debug output breaks cross-compilation
    separateDebugInfo = false;
  });

  linuxPackages_latest = previous.linuxPackages_latest.extend (self: super: {
    sun50i-a64-gpadc-iio = self.callPackage ./linux-packages/sun50i-a64-gpadc-iio {};
  });

  n3h = callPackage ./n3h {};

  rust = previous.rust // {
    packages = previous.rust.packages // {
      nightly = {
        rustPlatform = final.makeRustPlatform {
          inherit (buildPackages.rust.packages.nightly) cargo rustc;
        };

        cargo = final.rust.packages.nightly.rustc;
        rustc = (rustChannelOf {
          channel = "nightly";
          date = "2019-07-14";
          sha256 = "1llbwkjkjis6rv0rbznwwl0j6bf80j38xgwsd4ilcf0qps4cvjsx";
        }).rust.override {
          targets = [
            "aarch64-unknown-linux-musl"
            "wasm32-unknown-unknown"
            "x86_64-pc-windows-gnu"
            "x86_64-unknown-linux-musl"
          ];
        };
      };
    };
  };
}
