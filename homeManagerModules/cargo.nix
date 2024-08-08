{ config, pkgs, ... }:
let
  cfg = config.userConfig.cargo;
in
{
  options.userConfig.cargo = { };

  config.home.file.".cargo/config.toml".text = # toml
    ''
      [build]
      rustc-wrapper = "${pkgs.sccache}/bin/sccache"
    '';
}
