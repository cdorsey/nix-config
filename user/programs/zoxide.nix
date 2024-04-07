{ lib, config, ... }:
with lib;
let cfg = config.userConfig.zoxide;
in {
  options.userConfig.zoxide = {
    enable = mkEnableOption { };
    useCd = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.programs.zoxide = mkMerge [
    ({
      enable = cfg.enable;
      enableZshIntegration = config.userConfig.zsh.enable;
    })

    (mkIf cfg.useCd { options = [ "--cmd" "cd" ]; })
  ];
}
