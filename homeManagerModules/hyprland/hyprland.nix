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
      ]
  );
  terminal = lib.getExe config.programs.wezterm.package;
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
      exec-once = [ statusBar ];

      env = [ "QT_WAYLAND_DISABLE_WINDOWDECORATION,1" ];

      general = {
        layout = "master";

        gaps_in = 5;
        gaps_out = 5;
        border_size = 1;
        "col.active_border" = "rgba(88888888)";
        "col.inactive_border" = "rgba(00000088)";

        allow_tearing = true;
        resize_on_border = true;
      };

      bind =
        mkSuperBinds [
          "GRAVE, exec, ${terminal}"
          "E, exec, ${fileManager}"
          "SPACE, exec, ${menu}"
          "B, exec, ${browser}"
          "V, togglefloating,"
          "Q, killactive,"
          "S, exec, ${screenshot} -m region"
        ]
        ++ workspaceBinds
        ++ [
          "SUPER SHIFT, S, exec, ${screenshot} -m window"
          "SUPER ALT, S, exec, ${screenshot} -m output"
        ];

      bindm = mkSuperBinds [
        "mouse:272, movewindow"
        "mouse:273, resizewindow"
      ];

      gestures.workspace_swipe = true;

      input.touchpad = {
        natural_scroll = false;
        scroll_factor = 0.1;
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
        rounding = 16;
        blur = {
          enabled = true;
          brightness = 1.0;
          contrast = 1.0;
          noise = 1.0e-2;

          vibrancy = 0.2;
          vibrancy_darkness = 0.5;

          passes = 4;
          size = 7;

          popups = true;
          popups_ignorealpha = 0.2;
        };

        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_offset = "0 15";
        shadow_range = 100;
        shadow_render_power = 2;
        shadow_scale = 0.97;
        "col.shadow" = "rgba(00000055)";
      };

      animations = {
        enabled = true;
        animation = [
          "border, 1, 2, default"
          "fade, 1, 4, default"
          "windows, 1, 3, default, popin 80%"
          "workspaces, 1, 2, default, slide"
        ];
      };

      windowrulev2 = [ "suppressevent maximize, class:.*" ];

      monitor = [
        "eDP-1, preferred, auto, 1.6, vrr, 1"
        ", preferred, auto, 1"
      ];

      xwayland.force_zero_scaling = true;
    };

    xwayland.enable = true;
  };
}
