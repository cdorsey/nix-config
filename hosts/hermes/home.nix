{
  config,
  nix-colors,
  inputs,
  colorScheme,
  ...
}:
{
  imports = [
    nix-colors.homeManagerModules.default
    # inputs.hyprland.homeManagerModules.default
    # ../../homeManagerModules/alacritty
    ../../homeManagerModules/bat
    ../../homeManagerModules/cargo
    ../../homeManagerModules/fzf
    ../../homeManagerModules/git
    # ../../homeManagerModules/hyprland
    ../../homeManagerModules/jj
    ../../homeManagerModules/nvim
    ../../homeManagerModules/poetry
    ../../homeManagerModules/starship
    ../../homeManagerModules/syncthing
    ../../homeManagerModules/wezterm
    ../../homeManagerModules/zellij
    ../../homeManagerModules/zoxide
    ../../homeManagerModules/zsh
  ];

  home.username = "chase";
  home.homeDirectory = "/home/chase";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  colorScheme = colorScheme;

  userConfig = {
    git = {
      userName = "Chase Dorsey";
      userEmail = "git@chase-dorsey.com";
    };
  };

  programs.direnv = {
    enable = true;

    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
