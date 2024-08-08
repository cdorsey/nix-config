{
  lib,
  config,
  pkgs,
  nix-colors,
  root-dir,
  ...
}:
with lib;
let
  inherit (nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
  cfg = config.userConfig.zsh;
in
{
  options.userConfig.zsh = {
    enableOMZ = mkOption {
      type = types.bool;
      default = true;
    };
    enableAutoSuggestion = mkOption {
      type = types.bool;
      default = true;
    };
    enableHighlight = mkOption {
      type = types.bool;
      default = true;
    };
    plugins = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config.programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = cfg.enableAutoSuggestion;

    syntaxHighlighting.enable = cfg.enableHighlight;

    oh-my-zsh = {
      enable = cfg.enableOMZ;

      theme = "custom";
      custom = "${root-dir}/oh-my-zsh";
      plugins = [
        "git"
        "node"
        "docker-compose"
      ] ++ cfg.plugins;
    };

    shellAliases = {
      cat = "bat -pp";
      ls = "exa";
      http = "xh";
      https = "xh -s";
      ssh = "TERM=xterm-256color ssh";
    };

    initExtraFirst = ''
      . ${shellThemeFromScheme { scheme = config.colorScheme; }}
    '';
  };
}
