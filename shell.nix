{ pkgs ? import ./. {} }:

with pkgs;

let
  root = toString ./.;
in

mkShell {
  buildInputs = [ nixpkgs-fmt ];

  shellHook = ''
    hpos-shell() {
      $(nix-build -I nixos-config=${root}/profiles/holoportos/$1 \
        --attr holoportos.qemu \
        --no-out-link \
        --show-trace)/bin/run-holoportos-vm
    }

    hpos-switch() {
      sudo -E nixos-rebuild switch --fast -I nixos-config=/etc/nixos/configuration.nix
    }
  '';

  NIX_PATH = builtins.concatStringsSep ":" [
    "holo-nixpkgs=${root}"
    "nixpkgs=${pkgs.path}"
    "nixpkgs-overlays=${root}/overlays"
  ];
}
