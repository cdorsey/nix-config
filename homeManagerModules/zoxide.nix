{ lib, config, ... }:
with lib;
let
  cfg = config.userConfig.zoxide;
in
{
  options.userConfig.zoxide = {
    useCd = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.programs.zoxide = mkMerge [
    ({
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
    })

    (mkIf cfg.useCd {
      options = [
        "--cmd"
        "cd"
      ];
    })
  ];
}
