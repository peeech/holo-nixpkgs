{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.holo-auth-client;
in

{
  options.services.holo-auth-client = {
    enable = mkEnableOption "Holo Auth Client";

    package = mkOption {
      default = pkgs.holo-auth-client;
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.holo-auth-client = {
      after = [ "network.target" "zerotierone.service" ];

      path = with pkgs; [
        hpos-init
        hpos-state-derive-keystore
        jq
        utillinux
        zerotierone
      ];

      wantedBy = [ "multi-user.target" ];

      script = ''
        zerotier_status() {
          zerotier-cli -j listnetworks | jq -r .[0].status
        }

        sleep 10

        while [ "$(zerotier_status)" = "REQUESTING_CONFIGURATION" ]; do
          sleep 1
        done

        if [ "$(zerotier_status)" = "ACCESS_DENIED" ] \
            || [ ! -s holo-keystore ] || [ ! -s holo-keystore.pub ]; then
          # Not yet authorized w/ Zerotier, or the derived keystore is missing/empty
          export HPOS_STATE_PATH=$(hpos-init)

          mkdir -p /var/lib/holochain-conductor
          cd /var/lib/holochain-conductor

          if ! hpos-state-derive-keystore < $HPOS_STATE_PATH > holo-keystore 2> holo-keystore.pub; then
            echo 1>&2 "Failed to derive keys from $HPOS_STATE_PATH"
            exit 1
          fi
          export HOLO_PUBLIC_KEY=$(cat holo-keystore.pub)

          exec ${cfg.package}/bin/holo-auth-client
        fi
      '';

      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
