{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    theme = "${config.programs.rofi.package}/share/rofi/themes/android_notification.rasi";
  };
}
