{ ... }:
{
  programs.nixvim.plugins.auto-session = {
    enable = true;

    autoSession = {
      allowedDirs = [ "~/code/" ];
    };
  };
}
