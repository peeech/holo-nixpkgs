{ config, pkgs, ... }:

let
  nixpkgs = import ../../../vendor/nixpkgs;
in

{
  imports = [
    "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    ../.
  ];

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
