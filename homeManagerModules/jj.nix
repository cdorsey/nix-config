{ config, ... }:
let
  cfg = config.userConfig.git;
in
{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = cfg.userName;
        email = cfg.userEmail;
      };

      ui = {
        default-command = "log";
      };
    };
  };
}
