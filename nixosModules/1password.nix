{ ... }:
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
}
