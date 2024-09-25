{ ... }:
{
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal = {
          family = "FiraMono Nerd Font Mono";
          style = "Regular";
        };

        size = 12;
      };

      window = {
        padding = {
          x = 3;
          y = 3;
        };
        position = {
          x = 900;
          y = 350;
        };
        dimensions = {
          lines = 40;
          columns = 125;
        };
        # dynamic_padding = true;
        opacity = 0.9;
      };
    };
  };

}
