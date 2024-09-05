{ pkgs, ... }:
let
  cursorTheme = "Bibata";
  cursorSize = 32;
in
{
  xdg.dataFile."icons/${cursorTheme}".source = ../../assets/cursorTheme;

  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "HYPRCURSOR_THEME,${cursorTheme}"
        "HYPRCURSOR_SIZE,${toString cursorSize}"
      ];

      exec-once = [ "hyprctl setcursor ${cursorTheme} ${toString cursorSize}" ];
    };
  };
}
