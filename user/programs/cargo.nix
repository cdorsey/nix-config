{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.userConfig.cargo;
in {
  options.userConfig.cargo = {
    enable = mkEnableOption {};
  };

  config.home.file = mkIf cfg.enable {
    ".cargo/config.toml".text = ''
      [build]
      rustc-wrapper = "${pkgs.sccache}/bin/sccache"
    '';
  };
}
