{ config, ... }:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;

    polkitPolicyOwners = [ "chase" ];
  };

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      firefox
    '';
    mode = "0755";
  };

  systemd.user.services._1password = {
    enable = true;
    description = "1password";
    environment = {
      DISPLAY = ":0";
    };

    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "exec";
      ExecStart = "${config.programs._1password-gui.package}/bin/1password --silent";
      StandardOutput = "journal";
      StandardError = "journal";
      Restart = "on-failure";
      RestartSec = "10s";
      OOMPolicy = "continue";
    };
  };
}
