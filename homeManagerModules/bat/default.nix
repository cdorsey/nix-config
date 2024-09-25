{
  lib,
  config,
  nix-colors,
  pkgs,
  ...
}:
with lib;
let
  inherit (nix-colors.lib-contrib { inherit pkgs; }) textMateThemeFromScheme;
  cfg = config.userConfig.bat;
in
{
  options.userConfig.bat = { };

  config.programs.bat = {
    enable = true;

    config.theme = "base16";
    themes.base16.src = textMateThemeFromScheme { scheme = config.colorScheme; };
  };
}
