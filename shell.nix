{ pkgs ? import ./. {} }:

with pkgs;

let
  root = toString ./.;
in

stdenvNoCC.mkDerivation {
  name = "holo-nixpkgs";

  shellHook = ''
    holoportos-build-vm() {
      nixos-rebuild build-vm --fast -I nixos-config="${root}/profiles/targets/$1"
    }

    holoportos-switch() {
      sudo -E nixos-rebuild switch --fast -I nixos-config=/etc/nixos/configuration.nix
    }

    holoportos-shell() {
      holoportos-build-vm "$1" && ./result/bin/run-holoportos-vm
    }

    holoportos-run-vm() {
      holoportos-shell "$1"
      # https://no-color.org
      [[ -v NO_COLOR ]] || printf '\033[1;33m'
      echo "holoportos-run-vm is deprecated! Instead, use: holoportos-shell $1"
      [[ -v NO_COLOR ]] || printf '\033[0m'
    }
  '';

  NIX_PATH = builtins.concatStringsSep ":" [
    "holo-nixpkgs=${root}"
    "nixpkgs=${pkgs.path}"
    "nixpkgs-overlays=${root}/overlays"
  ];

  QEMU_OPTS = "-m 2048 -nographic";
}
