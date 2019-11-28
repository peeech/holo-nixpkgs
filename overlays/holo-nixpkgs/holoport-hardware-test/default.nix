{ lib
, makeWrapper
, runCommand
, substituteAll
, bash
, coreutils
, gawk
, gnugrep
, lshw
, mmc-utils
, smartmontools
, stress-ng
, target ? "holoport"
}:

let
  script = substituteAll {
    src = ./holoport-hardware-test.sh;
    isExecutable = true;

    inherit bash;
    path = lib.makeBinPath [
      coreutils
      gawk
      gnugrep
      lshw
      mmc-utils
      smartmontools
      stress-ng
    ];
  };
in

runCommand "holoport-hardware-test" {
  nativeBuildInputs = [ makeWrapper ];
  meta.platforms = lib.platforms.linux;
} ''
  makeWrapper ${script} $out/bin/holoport-hardware-test --add-flags "${target}"
''
