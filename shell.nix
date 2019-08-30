{ pkgs ? import ./. {} }:

with pkgs;

let
  root = toString ./.;
in

stdenvNoCC.mkDerivation {
  name = "holo-nixpkgs";

  shellHook = ''
    holoportos-switch() {
      sudo -E nixos-rebuild switch --fast -I nixos-config=/etc/nixos/configuration.nix
    }

    holoportos-shell() {
      $(nix-build release.nix -A holoportos.targets.qemu --no-out-link)/bin/run-holoportos-vm
    }
  '';

  NIX_PATH = builtins.concatStringsSep ":" [
    "holo-nixpkgs=${root}"
    "nixpkgs=${pkgs.path}"
    "nixpkgs-overlays=${root}/overlays"
  ];

  QEMU_OPTS = "-m 2048 -nographic";
}
