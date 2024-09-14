{ pkgs, config, ... }:
pkgs.writeShellScriptBin "deploy-atlas" ''
  set -ex

  ${pkgs.nixos-anywhere}/bin/nixos-anywhere --copy-host-keys --flake '${config.myNixOS.flakePath}#atlas' adguard@192.168.1.2
''
