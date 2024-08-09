{
  lib,
  config,
  pkgs,
  ...
}:
let
  mkSuperBinds = map (bind: "SUPER, ${bind}");
  terminal = lib.getExe config.programs.alacritty.package;
  fileManager = lib.getExe pkgs.nautilus;
  menu = lib.strings.concatStringsSep " " [
    (lib.getExe config.programs.rofi.package)
    "-show"
    "drun"
  ];
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

      bind = mkSuperBinds [
        "Q, exec, ${terminal}"
        "E, exec, ${fileManager}"
        "SPACE, exec, ${menu}"
        "V, togglefloating,"
      ];

      bindm = mkSuperBinds [
        "mouse:272, movewindow"
        "mouse:273, resizewindow"
      ];

      gestures.workspace_swipe = true;

      input.touchpad = {
        natural_scroll = false;
      };

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
    };
  };
}
