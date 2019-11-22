{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holo-monitor;
in

{
  options.services.holo-monitor = {
    enable = mkEnableOption "Holo Monitor";

    package = mkOption {
      default = pkgs.holo-monitor;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
  systemd = {
    timers.holo-monitor = {
      wantedBy = [ "timers.target" ];
      partOf = [ "holo-monitor.service" ];
      timerConfig.OnCalendar = "*:0/10";
    };
    services.holo-monitor = {
        after = [ "network.target" "holochain-conductor.service" ];
        path = [ config.services.holochain-conductor.package ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          EnvironmentFile="./.env";
          ExecStart = "${pkgs.nodejs-12_x}/bin/node ${pkgs.holo-monitor}/src/main.js";
          KillMode = "process";
          Restart = "always";
        };
      };
   };
  };
}
