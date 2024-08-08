{ nix-colors, inputs, ... }:
{
  imports = [
    nix-colors.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
    ../../homeManagerModules/bat.nix
    ../../homeManagerModules/cargo.nix
    ../../homeManagerModules/fzf.nix
    ../../homeManagerModules/git.nix
    ../../homeManagerModules/poetry.nix
    ../../homeManagerModules/nvim.nix
    ../../homeManagerModules/zellij.nix
    ../../homeManagerModules/zoxide.nix
    ../../homeManagerModules/zsh.nix
    ../../homeManagerModules/syncthing.nix
    ../../homeManagerModules/jj.nix
  ];

  home.username = "chase";
  home.homeDirectory = "/home/chase";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  colorScheme = nix-colors.colorSchemes.chalk;
  #colorScheme = nix-colors.colorSchemes.cupcake;

  userConfig = {
    git = {
      userName = "Chase Dorsey";
      userEmail = "git@chase-dorsey.com";
    };

    # cargo.enable = true;

    # fzf.enable = true;

    #poetry.enable = true;

    #vim.enable = true;

    # zellij.enable = true;

    # zoxide.enable = true;

    # zsh.enable = true;
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
        position = {
          x = 900;
          y = 350;
        };
        dimensions = {
          lines = 40;
          columns = 125;
        };
        # dynamic_padding = true;
        opacity = 0.9;
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
