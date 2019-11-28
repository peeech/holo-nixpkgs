{ makeTest, lib, hpos-admin-client, hpos-state-gen-cli }:

makeTest {
  name = "hpos-admin";

  machine = {
    imports = [ (import ../../profiles) ];

    documentation.enable = false;

    environment.systemPackages = [
      hpos-admin-client
      hpos-state-gen-cli
    ];

    services.hpos-admin.enable = true;

    services.nginx = {
      enable = true;
      virtualHosts.localhost = {
        locations."/".proxyPass = "http://unix:/run/hpos-admin.sock:/";
      };
    };
  };

  testScript = ''
    startAll;

    $machine->succeed(
      "hpos-state-gen-cli --email test\@holo.host --password : --seed-from ${./seed.txt} > /etc/hpos-state.json"
    );

    $machine->systemctl("start hpos-admin.service");
    $machine->waitForUnit("hpos-admin.service");
    $machine->waitForFile("/run/hpos-admin.sock");

    $machine->succeed("chown nginx:nginx /run/hpos-admin.sock");
    $machine->succeed("hpos-admin-client --url=http://localhost put-config example KbFzEiWEmM1ogbJbee2fkrA1");

    my $expected_config = "{" .
      "'admin': {'email': 'test\@holo.host', 'public_key': 'p2CU1lI9j9DEoFvYr9ef9q2rj5Ohn98t0i55DINIVTc'}, " .
      "'example': 'KbFzEiWEmM1ogbJbee2fkrA1'" .
    "}";

    my $actual_config = $machine->succeed("hpos-admin-client --url=http://localhost get-config");
    chomp($actual_config);

    die "unexpected config" unless $actual_config eq $expected_config;

    $machine->shutdown;
  '';

  meta.platforms = lib.platforms.linux;
}
