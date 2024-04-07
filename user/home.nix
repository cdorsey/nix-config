{ config, pkgs, rootDir, nix-colors, ... }: {
  imports = [
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/vim.nix
    ./programs/zellij.nix
    ./programs/zoxide.nix
    ./programs/fzf.nix
    ./programs/bat.nix
    ./programs/cargo.nix
    ./programs/poetry.nix
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    poetry
  ];

  # colorScheme = nix-colors.colorSchemes.material-darker;
  # colorScheme = nix-colors.colorSchemes.primer-dark;
  colorScheme = nix-colors.colorSchemes.chalk;

  userConfig = {
    git = {
      enable = true;

      userName = "Chase Dorsey";
      userEmail = "git@chase-dorsey.com";
    };

    zsh.enable = true;

    vim.enable = true;

    zellij.enable = true;

    fzf.enable = true;

    zoxide.enable = true;

    cargo.enable = true;

    poetry.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
