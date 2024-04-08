{ lib, config, pkgs, nix-colors, ... }:
with lib;
let
  cfg = config.userConfig.zellij;
  mkPlugin = name: { "${name}" = { path = name; }; };
in {
  options.userConfig.zellij = {
    enable = mkEnableOption { };
    autoAttach = mkOption {
      type = types.bool;
      default = true;
    };
    autoExit = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = {
    programs.zellij = {
      enable = cfg.enable;

      enableZshIntegration = config.userConfig.zsh.enable;

      settings = {
        pane_frames = false;
        mouse_mode = true;

        plugins = mkMerge [
          (mkPlugin "tab-bar")
          #(mkPlugin "status-bar")
          (mkPlugin "strider")
          (mkPlugin "compact-bar")
        ];

        themes = with config.colorScheme.palette; {
          default = {
            fg = "#${base06}";
            bg = "#${base00}";
            black = "#${base00}";
            white = "#${base06}";
            red = "#${base08}";
            orange = "#${base09}";
            yellow = "#${base0A}";
            green = "#${base0B}";
            blue = "#${base0C}";
            cyan = "#${base0D}";
            magenta = "#${base0E}";
          };
        };
      };
    };

    home.sessionVariables = mkMerge [
      (mkIf cfg.autoAttach { ZELLIJ_AUTO_ATTACH = "true"; })
      (mkIf cfg.autoExit { ZELLIJ_AUTO_EXIT = "true"; })
    ];
  };
}
