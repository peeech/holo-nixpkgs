{ config, pkgs, ... }:

let
  nixpkgs = import ../../../nixpkgs/source.nix;

  tmuxConfig = pkgs.writeText "tmux.conf" ''
    set -g default-shell ${pkgs.bashInteractive}/bin/bash
    set -g status-interval 1
    set -g status-right "#(${pkgs.jq}/bin/jq --from-file ${./aorura-tmux-status.jq} --raw-output < ${config.services.hpos-led-manager.statePath})"
    set -g status-style bg=white,fg=black
  '';

  tmuxWrapper = pkgs.writeShellScriptBin "tmux" ''
    export TERM=xterm-256color
    source <( ${pkgs.xterm}/bin/resize )
    ${pkgs.tmux}/bin/tmux -f ${tmuxConfig}
    ${pkgs.systemd}/bin/poweroff
  '';
in

{
  imports = [
    "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
  ];

  services.aorura-emu.enable = true;

  services.hpos-led-manager = {
    enable = true;
    devicePath = config.services.aorura-emu.path;
  };

  users.users.root.shell = "${tmuxWrapper}/bin/tmux";

  virtualisation = {
    diskSize = 3072;
    graphics = false;
    memorySize = 2048;
    useBootLoader = false;
  };
}
