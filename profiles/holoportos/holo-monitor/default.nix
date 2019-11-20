{ config, lib, pkgs, ... }:

with pkgs;

let
  conductorHome = config.users.users.holochain-conductor.home;

  dnas = with dnaPackages; [
    holo-hosting-app
  ];

  dnaConfig = drv: {
    id = drv.name;
    file = "${drv}/${drv.name}.dna.json";
    hash = pkgs.dnaHash drv;
  };

  instanceConfig = drv: {
    agent = "holo-monitor-agent";
    dna = drv.name;
    id = drv.name;
    storage = {
      path = "${conductorHome}/${drv.name}";
      type = "file";
    };
  };

in

{
  imports = [ ../. ];

  environment.systemPackages = [ pkgs.holo-monitor ];
  services.holo-monitor.enable = true;

  services.holochain-conductor = {
    enable = true;
    config = {
      agents = [{
        id = "holo-monitor-agent";
        name = "Holo Monitor Agent";
        keystore_file = "${conductorHome}/holo";
        public_address = "@public_key@";
      }];
      bridges = [];
      dnas = map dnaConfig dnas;
      instances = map instanceConfig dnas;
      network = {
        bootstrap_nodes = [];
        n3h_persistence_path = "${conductorHome}/.n3h";
        type = "n3h";
      };
      persistence_dir = conductorHome;
      interfaces = [
      {
        driver = {
          port = 8800;
          type = "websocket";
        };
        id = "master-interface";
        instances = map (drv: { id = drv.name; }) dnas;
      }
      {
        admin = true;
        id = "public-interface";
        driver = {
          port = 8080;
          type = "http";
        };
      }
    ];
    };
  };
}
