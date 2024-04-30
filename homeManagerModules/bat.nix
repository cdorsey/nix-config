{
  lib,
  config,
  nix-colors,
  ...
}:
with lib;
let
  inherit (nix-colors.lib-contrib { inherit pkgs; }) textMateThemeFromScheme;
  cfg = config.userConfig.bat;
in
{
  options.userConfig.bat = {
    enable = mkEnableOption { };
  };

  config.programs.bat = {
    enable = cfg.enable;

    config.theme = "base16";
    themes.base16.src = textMateThemeFromScheme { scheme = config.colorScheme; };
  };
}
