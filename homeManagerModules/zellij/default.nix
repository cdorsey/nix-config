{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.userConfig.zellij;
  mkPlugin = name: {
    "${name}" = {
      path = name;
    };
  };
in
{
  options.userConfig.zellij = {
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
      enable = true;

      enableZshIntegration = config.programs.zsh.enable;

      settings = {
        pane_frames = false;
        mouse_mode = true;
        copy_on_select = true;
        copy_clipboard = "primary";

        plugins = mkMerge [
          (mkPlugin "tab-bar")
          (mkPlugin "status-bar")
          (mkPlugin "strider")
          (mkPlugin "compact-bar")
        ];

        themes = with config.colorScheme.palette; {
          default = {
            fg = "#${base06}";
            bg = "#${base0C}";
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

    # nixpkgs.overlays = [
    #   (final: prev: { zjstatus = inputs.zjstatus.packages.${prev.system}.default; })
    # ];

    home.packages = [
      pkgs.zjstatus
    ];

    xdg.configFile."zellij/layouts/default.kdl".text = with config.colorScheme.palette; ''
        layout {
          default_tab_template {
            pane size=2 borderless=true {
              plugin location="file://${pkgs.zjstatus}/bin/zjstatus.wasm" {
              format_left   "{mode} #[fg=#${base0D},bold]{session}"
              format_center "{tabs}"
              format_right  "{command_git_branch} {datetime}"
              format_space  ""

              border_enabled  "true"
              border_char     "─"
              border_format   "#[fg=#${base01}]{char}"
              border_position "bottom"

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
              datetime_timezone "US/Eastern"
            }
          }
          children
        }
      }
    '';
  };
}
