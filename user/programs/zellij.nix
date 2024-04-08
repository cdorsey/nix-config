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
          (mkPlugin "status-bar")
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

    xdg.configFile."zellij/layouts/default.kdl".text =
      with config.colorScheme.palette; ''
          layout {
            default_tab_template {
              children
              pane size=1 borderless=true {
                plugin location="file://${pkgs.zjstatus}/bin/zjstatus.wasm" {
                format_left   "{mode} #[fg=#${base0D},bold]{session}"
                format_center "{tabs}"
                format_right  "{command_git_branch} {datetime}"
                format_space  ""

                border_enabled  "true"
                border_char     "─"
                border_format   "#[fg=#${base01}]{char}"
                border_position "top"

                hide_frame_for_single_pane "true"

                mode_normal  "#[bg=#${base0C},fg=#${base00}] {name} "
                mode_tmux    "#[bg=#${base0B},fg=#${base00}] {name} "

                tab_normal   "#[fg=#${base03}] {name} "
                tab_active   "#[fg=#${base06},bold,italic] {name} "

                command_git_branch_command     "${pkgs.git}/bin/git rev-parse --abbrev-ref HEAD"
                command_git_branch_format      "#[fg=#${base0C}] {stdout} "
                command_git_branch_interval    "10"
                command_git_branch_rendermode  "static"

                datetime        "#[fg=#${base04},bold] {format} "
                datetime_format "%A, %d %b %Y %H:%M"
                datetime_timezone "US/Central"
              }
            }
          }
        }
      '';
  };
}
