{
  disabledModules = [
    "system/boot/loader/generic-extlinux-compatible"
  ];

  imports = [
    ./boot/generic-extlinux-compatible.nix
    ./services/holo-envoy.nix
    ./services/holo-monitor.nix
    ./services/holochain-conductor.nix
    ./system/holoportos.nix
    ./system/holoportos/auto-upgrade.nix
    ./system/holoportos/install.nix
    ./system/holoportos/led-daemon.nix
  ];
}
