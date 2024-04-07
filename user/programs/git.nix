{ lib, config, ... }:
with lib;
let cfg = config.userConfig.git;
in {
  options.userConfig.git = {
    enable = mkEnableOption { };
    userEmail = mkOption { type = types.str; };
    userName = mkOption { type = types.str; };
  };

  config.programs.git = {
    enable = cfg.enable;

    userEmail = cfg.userEmail;
    userName = cfg.userName;

    extraConfig = { init.defaultBranch = "main"; };
  };
}
