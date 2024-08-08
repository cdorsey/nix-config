{ config, ... }:
let
  cfg = config.userConfig.poetry;
in
{
  options.userConfig.poetry = { };

  config.xdg.configFile."pypoetry/config.toml".text = # toml
    ''
      [virtualenvs]
      in-project = true
    '';
}
