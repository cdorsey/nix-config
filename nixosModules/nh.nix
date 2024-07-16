{ config, lib, ... }:
let
  cfg = config.myNixOS;
in
{
  options.myNixOS.flakePath = lib.mkOption { description = "Where flake files are located"; };

  config.programs.nh = {
    enable = true;

    flake = cfg.flakePath;

    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
  };
}
