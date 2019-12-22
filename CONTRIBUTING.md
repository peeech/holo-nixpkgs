## Branch protection rules

`develop` requires signed commits, passing CI and pull request with at least
one review. Code owners may waive some of restrictions for individual pull
requests in special circumstances.

`master` requires signed commits, passing CI and pull request with at least two
reviews, both of which must be made against the most recent tip of the branch.
If any, code owner reviews are mandatory. Change request reviews can't be
dismissed. Administrators or code owners must not waive any restrictions.

## Commit message style guide

See: https://nixos.org/nixpkgs/manual/#submitting-changes-making-patches

## Formatting

Use `find . -name \*.nix -exec nixpkgs-fmt {} +` inside `nix-shell`.

## Iterate on overlay packages

First, enter `nix-shell`. This sets up reproducible development environment.

Then, add a new package to `overlays/holo-nixpkgs/default.nix` in alphabetical order:

```nix
{
  foo = callPackage ./foo {};
}
```

Write the derivation in `overlays/holo-nixpkgs/foo/default.nix`.

To test if it builds, run `nix-build -A foo`.

## Iterate on NixOS modules/profiles

First, enter `nix-shell`.

To test HoloPortOS in a VM for a generic target, run `holoportos-shell`. First
argument can optionally specify a custom target: for example, to test
[`profiles/holoportos/demo`](profiles/holoportos/demo/default.nix) profile,
you'd run `holoportos-shell demo`.

If you want to build a VM without entering it, use `holoportos-build-vm`
instead of `holoportos-shell`. It similarly supports an optional target
argument.

To rebuild HoloPortOS directly on the current system, enter `nix-shell` and
then run `holoportos-switch`. This is useful for testing hardware support.
