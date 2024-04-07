{ lib, config, ... }:
let
  cfg = config.userConfig.git;
in {
  options.userConfig.git = {
    enable = lib.mkEnableOption {};
    userEmail = lib.mkOption {
      type = lib.types.str;
    };
    userName = lib.mkOption {
      type = lib.types.str;
    };
  };

  config.programs.git = {
    enable = cfg.enable;

    userEmail = cfg.userEmail;
    userName = cfg.userName;

    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}