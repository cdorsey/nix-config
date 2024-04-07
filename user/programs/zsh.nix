{ lib, config, pkgs, nix-colors, rootDir, ... }:
with lib;
let
  inherit (nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
  cfg = config.userConfig.zsh;
in {
  options.userConfig.zsh = {
    enable = mkEnableOption { };
    plugins = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config.programs.zsh = {
    enable = cfg.enable;
    enableCompletion = true;

    oh-my-zsh = {
      enable = cfg.enable;

      theme = "custom";
      custom = "${rootDir}/oh-my-zsh";
      plugins = [ "git" "node" "docker-compose" ] ++ cfg.plugins;
    };

    shellAliases = {
      cat = "bat -pp";
      ls = "exa";
      http = "xh";
      https = "xh -s";
    };

    initExtraFirst = ''
      . ${shellThemeFromScheme { scheme = config.colorScheme; }}
    '';
  };
}
