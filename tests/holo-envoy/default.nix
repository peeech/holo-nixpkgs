{ lib, makeTest }:

makeTest {
  name = "holo-envoy";

  machine = {
    imports = [ (import ../../profiles/holoportos/demo) ];
    virtualisation.memorySize = 3072;
  };

  testScript = ''
    startAll;
    # TODO: Revise these when the new envoy is integrated
    #$machine->systemctl("restart holochain-conductor.service");
    #$machine->systemctl("start holo-envoy.service");
    #$machine->waitForUnit("holochain-conductor.service");
    #$machine->waitForUnit("holo-envoy.service");
    #$machine->waitForOpenPort("1111");
    #$machine->waitForOpenPort("48080");
    $machine->shutdown;
  '';

  meta.platforms = lib.platforms.linux;
}
