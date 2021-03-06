{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holochain-conductor;

  inherit (config.users.users.holochain-conductor) home;
in

{
  options.services.holochain-conductor = {
    enable = mkEnableOption "Holochain Conductor";

    config = mkOption {
      type = types.attrs;
    };

    package = mkOption {
      default = pkgs.holochain-conductor;
      type = types.package;
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      holochain-cli
    ];

    systemd.services.holochain-conductor = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        holochain-cli
        holochain-conductor
      ];

      preStart = ''
        cat ${pkgs.writeTOML cfg.config} > ${home}/conductor-config.toml
        sed -i s/@public_key@/$(cat ${home}/holo-keystore.pub)/ ${home}/conductor-config.toml
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/holochain -c ${home}/conductor-config.toml";
        KillMode = "process";
        Restart = "always";
        User = "holochain-conductor";
      };
    };

    users.users.holochain-conductor = {
      createHome = true;
      home = "/var/lib/holochain-conductor";
    };
  };
}
