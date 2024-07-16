{ ... }:
{
  programs.firefox = {
    enable = true;
    policies = {
      DisablePocket = true;
      EnableTrackingProtection = true;
      Homepage.URL = "https://dash.homelab.chase-dorsey.com";
      StartPage = "homepage";
    };
  };
}
