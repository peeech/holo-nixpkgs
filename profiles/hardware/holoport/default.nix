{ lib, ... }:

{
  imports = [ ../. ];

  boot.loader.grub = {
    enable = lib.mkDefault true;
    devices = [ "/dev/sda" ];
  };

  services.hpos-led-manager = {
    devicePath = "/dev/ttyUSB0";
  };

  system.holoportos.target = "holoport";
}
