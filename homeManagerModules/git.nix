{ lib, config, ... }:
with lib;
let
  cfg = config.userConfig.git;
in
{
  options.userConfig.git = {
    userEmail = mkOption { type = types.str; };
    userName = mkOption { type = types.str; };
  };

  config.programs.git = {
    enable = true;

    userEmail = cfg.userEmail;
    userName = cfg.userName;

    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
