{ lib, python3Packages }:
with lib;
python3Packages.buildPythonApplication rec {
  name = "hpos-init";

  src = ./.;  
  propagatedBuildInputs = with python3Packages; [ magic-wormhole ];
  doCheck = false;

  meta.platforms = platforms.linux;
  
}
