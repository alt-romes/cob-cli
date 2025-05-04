{ pkgs ? import <nixpkgs> {}, ... }:
with pkgs;
mkShell {
  name = "cob-cli-shell";
  packages = [ (import ./default.nix { pkgs=pkgs; }) ];
}
