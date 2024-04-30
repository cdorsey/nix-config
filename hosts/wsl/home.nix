{
  config,
  pkgs-unstable,
  root-dir,
  nix-colors,
  ...
}:
{
  imports = [
    nix-colors.homeManagerModules.default
    ../../programs/bat.nix
    ../../programs/cargo.nix
    ../../programs/fzf.nix
    ../../programs/git.nix
    ../../programs/poetry.nix
    ../../programs/vim.nix
    ../../programs/zellij.nix
    ../../programs/zoxide.nix
    ../../programs/zsh.nix
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs-unstable; [ poetry ];

  colorScheme = nix-colors.colorSchemes.chalk;
  #colorScheme = nix-colors.colorSchemes.cupcake;

  userConfig = {
    git = {
      enable = true;

      userName = "Chase Dorsey";
      userEmail = "git@chase-dorsey.com";
    };

    cargo.enable = true;

    fzf.enable = true;

    poetry.enable = true;

    vim.enable = true;

    zellij.enable = true;

    zoxide.enable = true;

    zsh.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
