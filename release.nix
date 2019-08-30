{ pkgs ? import ./. {} }:

with pkgs;

let
  mkImage = profile:
    let
      allowCross = config.allowCross or true;

      nixos = import "${pkgs.path}/nixos" {
        configuration = { config, ... }: {
	  imports = [ profile ];

	  nixpkgs.localSystem.system = if allowCross
	    then builtins.currentSystem
	    else config.nixpkgs.hostPlatform.system;
	};
      };

      inherit (nixos.config.system) build;
      inherit (nixos.config.nixpkgs.hostPlatform) system;

      image = if build ? "isoImage"
        then build.isoImage
        else if build ? "sdImage"
        then build.sdImage
        else if build ? "virtualBoxOVA"
        then build.virtualBoxOVA
        else throw "${build} doesn't expose any known image format";

      stopgap = drv: if allowCross
        then drv
        else runCommand drv.name {} ''
          mkdir -p $out

          for f in ${drv}/*; do
            if [ "$f" = "${drv}/nix-support" ]; then
              cp -r $f $out
              chmod -R +w $out/$(basename $f)
            else
              cp -rs $f $out
            fi
          done

          for f in $out/nix-support/*; do
            substituteInPlace $f --replace ${drv} $out
          done
        '';
    in
    lib.recursiveUpdate (stopgap image) {
      meta.platforms = [ system ];
    };
in

{
  holoportos = recurseIntoAttrs {
    installers = recurseIntoAttrs {
      holoport = mkImage ./profiles/installers/holoport;
      holoport-nano = mkImage ./profiles/installers/holoport-nano;
      holoport-plus = mkImage ./profiles/installers/holoport-plus;
    };
    targets = recurseIntoAttrs {
      virtualbox = mkImage ./profiles/targets/virtualbox;
    };
  };

  tests = recurseIntoAttrs {
    boot = import ./tests/boot.nix { inherit pkgs; };
  };
}
