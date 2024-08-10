{ lib, pkgs, ... }:
{
  programs.waybar = {
    enable = true;

    style = ./waybar.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 31;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
          # "idle_inhibitor"
        ];
        modules-right = [
          "tray"
          # "custom/scratchpad-indicator"
          "pulseaudio"
          "network"
          "custom/power"
        ];

        "hyprland/submap" = {
          format = ''<span style="italic">{}</span>'';
        };

        "hyprland/window" = {
          "separate-outputs" = true;
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}% )";
          format-ethernet = "{ifname} ";
          format-disconnected = "";
        };

        # "idle_inhibitor" = {
        #   format = "icon";
        #   format-icons = {
        #     activated = "";
        #     deactivated = "";
        #   };
        # };

        tray = {
          icon-size = 15;
          spacing = 10;
        };

        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%a %b %e, %Y %I:%M %p}";
          # format-alt = "{:%Y-%m-%d}";
          # on-click = "gnome-calendar";
        };

        pulseaudio = {
          format = "{volume}% {icon} ";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = "0% {icon} ";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "${lib.getExe pkgs.pavucontrol}";
        };

        "custom/power" = {
          format = " ";
          # on-click = "swaynag -t warning -m 'Power Menu Options' -b 'Logout' 'swaymsg exit' -b 'Restart' 'shutdown -r now' -b 'Shutdown'  'shutdown -h now' --background=#005566 --button-background=#009999 --button-border=#002b33 --border-bottom=#002b33";
        };

        # "custom/scratchpad-indicator" = {
        #   format-text = "{}hi";
        #   return-type = "json";
        #   interval = 3;
        #   exec = "~/.local/bin/scratchpad-indicator 2> /dev/null";
        #   exec-if = "exit 0";
        #   on-click = "swaymsg 'scratchpad show'";
        #   on-click-right = "swaymsg 'move scratchpad";
        # };
      };
    };
  };
}
