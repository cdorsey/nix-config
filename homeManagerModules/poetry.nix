{ lib, config, ... }:
with lib;
let
  cfg = config.userConfig.poetry;
in
{
  options.userConfig.poetry = {
    enable = mkEnableOption { };
  };

  config.xdg.configFile = mkIf cfg.enable {
    "pypoetry/config.toml".text = ''
      [virtualenvs]
      in-project = true
    '';
  };
}
