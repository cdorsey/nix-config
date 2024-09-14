{ pkgs, ... }:
let
  cursorTheme = "Bibata";
  cursorSize = 32;
in
{
  home.file.".icons/${cursorTheme}".source = ../../assets/cursorTheme;

  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "HYPRCURSOR_THEME,${cursorTheme}"
        "HYPRCURSOR_SIZE,${toString cursorSize}"
        "GTK_CURSOR_THEME,${cursorTheme}"
      ];

      exec-once = [ "hyprctl setcursor ${cursorTheme} ${toString cursorSize}" ];
    };
  };
}
