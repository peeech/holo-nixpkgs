{ stdenv, runCommand, makeWrapper, jq }:

runCommand "holofuel-demo-configure" { nativeBuildInputs = [ makeWrapper ]; } ''
  makeWrapper ${stdenv.shell} $out/bin/holofuel-demo-configure \
    --add-flags ${./holofuel-demo-configure.sh} \
    --prefix PATH : ${stdenv.lib.makeBinPath [ jq ]}
''
