{ lib, config, ... }:
with lib;
let cfg = config.userConfig.fzf;
in {
  options.userConfig.fzf = { enable = mkEnableOption { }; };

  config.programs.fzf = {
    enable = cfg.enable;

    enableZshIntegration = config.userConfig.zsh.enable;
  };
}
