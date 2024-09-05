{ config, ... }:
{
  programs.wezterm = {
    enable = true;

    enableZshIntegration = config.programs.zsh.enable;
    enableBashIntegration = config.programs.bash.enable;

    extraConfig = # lua
      ''
        return {
          font = wezterm.font {
            family = "FiraCode Nerd Font Mono",
            harfbuzz_features = { "ss07" }
          },
          font_size = 12,
          window_background_opacity = 0.9,
        }
      '';
  };
}
