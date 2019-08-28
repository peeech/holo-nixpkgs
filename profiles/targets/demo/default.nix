{ config, pkgs, ... }:

with pkgs;

let
  conductorHome = config.users.users.holochain-conductor.home;

  hApps = with hAppPackages; [
    happ-store
    holo-hosting-app
    holofuel
    servicelogger
  ];

  dnaHash = drv: builtins.readFile (runCommand "${drv.name}-hash" {} ''
    ${holochain-cli}/bin/hc hash -p ${drv}/${drv.name}.dna.json \
      | tail -1 \
      | cut -d ' ' -f 3- \
      | tr -d '\n' > $out
  '');

  dnaConfig = drv: {
    id = drv.name;
    file = "${drv}/${drv.name}.dna.json";
    hash = dnaHash drv;
  };

  instanceConfig = drv: {
    agent = "host-agent";
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

  environment.systemPackages = [ pkgs.holoportos-initialize ];

  networking.firewall.allowedTCPPorts = [ 1111 2222 3333 8800 8880 8888 48080 ];

  services.holo-envoy.enable = true;

  services.holochain-conductor = {
    enable = true;
    config = {
      agents = [{
        id = "host-agent";
        name = "Host Agent";
        keystore_file = "${conductorHome}/holoportos-key";
        public_address = "@public_key@";
      }];
      bridges = [];
      dnas = map dnaConfig hApps;
      instances = map instanceConfig hApps;
      network = {
        n3h_persistence_path = "${conductorHome}/.n3h";
        type = "n3h";
        bootstrap_nodes = [];
      };
      persistence_dir = conductorHome;
      signing_service_uri = "http://localhost:8888";
      interfaces = [
        {
          id = "master-interface";
          admin = true;
          driver = {
            port = 1111;
            type = "websocket";
          };
          instances = map (drv: { id = drv.name; }) hApps;
        }
        {
          id = "internal-interface-1";
          admin = false;
          driver = {
            port = 2222;
            type = "websocket";
          };
        }
        {
          id = "internal-interface-2";
          admin = false;
          driver = {
            port = 3333;
            type = "websocket";
          };
        }
      ];
    };
  };

  system.holoportos.network = "test";

  users.users.root.openssh.authorizedKeys.keys = [
    # Matthew Brisebois
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGakK6G+lvSpg3NKfuWNopUlI/Z2keLGBH09jeAVbslO"
    # Paul B Hartzog
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8w0/vpNXIRB/VPAnbE6RFWoL5DOlZ5x1KmCockehiE"
    # Perry Kundert
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILYMeKuFegEeM6L7/pJLSxgpyfrXXFOR1H/5C8liZWOL"
    # Yegor Timoshenko
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLGgzH3ROvo65cnvkXmuz7Qc9bPvU+L2SrafQh0bMrK"
  ];
}
