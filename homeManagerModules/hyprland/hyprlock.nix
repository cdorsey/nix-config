{ lib, config, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        # grace = 300;
        grace = 1;
        hide_cursor = true;

      };
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 10;
        }
      ];

      label = [
        {
          monitor = "";
          size = "400, 100";
          position = "0, 100";
          halign = "center";
          valign = "center";
          text_align = "center";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 200;
          shadow_passes = 2;
          text = "$TIME";
        }
      ];

      input-field = [
        {
          size = "200, 30";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "<i>Password</i>";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          shadow_passes = 2;
        }
      ];
    };
  };
}
