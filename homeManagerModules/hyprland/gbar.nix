{ inputs, pkgs, ... }:
{
  imports = [ inputs.gBar.homeManagerModules."x86_64-linux".default ];

  programs.gBar = {
    enable = true;

    config = {
      Location = "T";
      EnableSNI = true;
      WorkspaceSymbols = [
        " "
        " "
      ];
      DateTimeStyle = "%a, %b %e, %Y\t%I:%M %p";
    };
  };
}
