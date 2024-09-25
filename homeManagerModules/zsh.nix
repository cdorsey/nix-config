{
  self,
  lib,
  config,
  pkgs,
  nix-colors,
  ...
}:
with lib;
let
  inherit (nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
  inherit lib getExe;
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
    shellAliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
    };
  };

  config.programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = cfg.enableAutoSuggestion;

    syntaxHighlighting.enable = cfg.enableHighlight;

    oh-my-zsh = {
      enable = cfg.enableOMZ;

      # theme = "custom";
      # custom = "${self}/oh-my-zsh";
      plugins = [
        "git"
        "node"
        "docker-compose"
      ] ++ cfg.plugins;
    };

    shellAliases =
      with pkgs;
      {
        cat = "${getExe bat} -pp";
        ls = "${getExe eza}";
        http = "${xh}/bin/xh";
        https = "${xh}/bin/xhs";
        gcaf = "${getExe git} commit --all --fixup HEAD";
        ssh = "TERM=xterm-256color ssh";
      }
      // cfg.shellAliases;

    initExtraFirst = ''
      . ${shellThemeFromScheme { scheme = config.colorScheme; }}
    '';
  };
}
