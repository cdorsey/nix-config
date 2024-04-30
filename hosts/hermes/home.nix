{ nix-colors, ... }:
{
  imports = [
    nix-colors.homeManagerModules.default
    ../../homeManagerModules/bat.nix
    ../../homeManagerModules/cargo.nix
    ../../homeManagerModules/fzf.nix
    ../../homeManagerModules/git.nix
    ../../homeManagerModules/poetry.nix
    ../../homeManagerModules/vim.nix
    ../../homeManagerModules/nvim.nix
    ../../homeManagerModules/zellij.nix
    ../../homeManagerModules/zoxide.nix
    ../../homeManagerModules/zsh.nix
  ];

  home.username = "chase";
  home.homeDirectory = "/home/chase";

  home.stateVersion = "23.11"; # Please read the comment before changing.

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

    #poetry.enable = true;

    #vim.enable = true;

    zellij.enable = true;

    zoxide.enable = true;

    zsh.enable = true;
  };

  programs.direnv = {
    enable = true;

    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal = {
          family = "FiraMono Nerd Font Mono";
          style = "Regular";
        };

        size = 12;
      };

      window = {
        padding = {
          x = 3;
          y = 3;
        };
        dimensions = {
          columns = 100;
          lines = 25;
        };
        dynamic_padding = true;
        opacity = 0.9;
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
