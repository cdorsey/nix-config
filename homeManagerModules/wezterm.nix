{ config, pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;

    enableZshIntegration = config.programs.zsh.enable;
    enableBashIntegration = config.programs.bash.enable;
  };
}
