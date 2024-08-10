{
  lib,
  config,
  pkgs,
  ...
}:
let
  mkSuperBinds = map (bind: "SUPER, ${bind}");
  workspaceBinds = lib.lists.flatten (
    map
      (n: [
        "SUPER, ${toString n}, workspace, ${toString n}"
        "SUPER SHIFT, ${toString n}, movetoworkspace, ${toString n}"
      ])
      [
        1
        2
        3
        4
        5
        6
        7
        8
        9
        0
      ]
  );
  terminal = lib.getExe config.programs.alacritty.package;
  fileManager = lib.getExe pkgs.nautilus;
  statusBar = lib.getExe config.programs.waybar.package;
  menu = lib.strings.concatStringsSep " " [
    (lib.getExe config.programs.rofi.package)
    "-show"
    "drun"
  ];
  browser = lib.getExe config.programs.firefox.package;
  screenshot = lib.getExe pkgs.hyprshot;
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      general = {
        layout = "master";

        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };

      exec-once = [ statusBar ];

      bind =
        mkSuperBinds [
          "GRAVE, exec, ${terminal}"
          "E, exec, ${fileManager}"
          "SPACE, exec, ${menu}"
          "B, exec, ${browser}"
          "V, togglefloating,"
          "Q, killactive,"
          "S, exec, hyprshot -m region"
        ]
        ++ workspaceBinds
        ++ [
          "SUPER SHIFT, S, exec, hyprshot -m window"
          "SUPER ALT, S, exec, hyprshot -m output"
        ];

      bindm = mkSuperBinds [
        "mouse:272, movewindow"
        "mouse:273, resizewindow"
      ];

      gestures.workspace_swipe = true;

      input.touchpad = {
        natural_scroll = false;
      };

      device = [
        {
          name = "corsair-corsair-dark-core-rgb-pro-gaming-mouse";
          sensitivity = -0.8;
        }
        {
          name = "corsair-corsair-virtuoso-xt-wireless-gaming-receiver";
          sensitivity = -0.8;
        }
      ];

      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      windowrulev2 = [ "suppressevent maximize, class:.*" ];

      monitor = [
        "eDP-1, preferred, auto, 1.6, vrr, 1"
        ", preferred, auto, 1"
      ];
    };
  };
}
