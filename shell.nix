{ pkgs ? import ./. {} }:

with pkgs;

let
  root = toString ./.;
in

stdenvNoCC.mkDerivation {
  name = "holo-nixpkgs";

  shellHook = ''
    holoportos-build-vm() {
      $(nixos-rebuild build-vm -I nixos-config=${root}/profiles/targets/$1)
    }
    holoportos-run-vm() {
      $(nixos-rebuild build-vm -I nixos-config=${root}/profiles/targets/$1)
      ./result/bin/run-holoportos-vm
    }
    holoportos-switch() {
      sudo -E nixos-rebuild switch -I nixos-config=/etc/nixos/configuration.nix
    }
  '';

  buildInputs = [ ((nixos {}).nixos-rebuild) ];

  NIX_PATH = builtins.concatStringsSep ":" [
    "holo-nixpkgs=${root}"
    "nixpkgs=${pkgs.path}"
    "nixpkgs-overlays=${root}/overlays"
  ];

  QEMU_OPTS = "-m 2048 -nographic";
}
