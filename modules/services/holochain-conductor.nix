{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holochain-conductor;

  inherit (config.users.users.holochain-conductor) home;

  json = pkgs.writeText "dnscrypt-proxy.json" (builtins.toJSON cfg.config);

  toml = pkgs.runCommand "dnscrypt-proxy.toml" {} ''
    ${pkgs.remarshal}/bin/json2toml < ${json} > $out
  '';
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
        n3h
      ];

      preStart = ''
        mkdir -p ${cfg.config.network.n3h_persistence_path}
        cat ${toml} > ${home}/conductor-config.toml
        sed -i s/@public_key@/$(cat ${home}/holoportos-key.pub)/ ${home}/conductor-config.toml
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
