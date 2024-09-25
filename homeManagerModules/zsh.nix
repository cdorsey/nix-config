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
      let
        inherit (lib) getExe;
      in
      with pkgs;
      {
        cat = "${getExe bat} -pp";
        ls = "${getExe eza}";
        http = "${getExe xh}";
        https = "${getExe xh} -s";
        ssh = "TERM=xterm-256color ssh";
        gcaf = "${getExe git} log -n 50 --pretty=format:'%h %s' --no-merges | ${getExe fzf} | cut -c -7 | xargs -o ${getExe git} commit --all --fixup";
      }
      // cfg.shellAliases;

    initExtraFirst = ''
      . ${shellThemeFromScheme { scheme = config.colorScheme; }}
    '';
  };
}
