{ lib, config, ... }:
with lib;
let
  cfg = config.userConfig.fzf;
in
{
  options.userConfig.fzf = { };

  config.programs.fzf = {
    enable = true;

    enableZshIntegration = config.programs.zsh.enable;
  };
}
