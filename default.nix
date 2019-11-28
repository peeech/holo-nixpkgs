{ ... } @ args: import ./nixpkgs (
  args // {
    overlays = [ (import ./overlays/holo-nixpkgs) ] ++ (args.overlays or []);
  }
)
