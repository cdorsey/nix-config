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
    # ../../homeManagerModules/alacritty.nix
    ../../homeManagerModules/bat.nix
    ../../homeManagerModules/cargo.nix
    ../../homeManagerModules/fzf.nix
    ../../homeManagerModules/git.nix
    # ../../homeManagerModules/hyprland
    ../../homeManagerModules/jj.nix
    ../../homeManagerModules/nvim
    ../../homeManagerModules/poetry.nix
    ../../homeManagerModules/starship
    ../../homeManagerModules/syncthing.nix
    ../../homeManagerModules/wezterm.nix
    ../../homeManagerModules/zellij.nix
    ../../homeManagerModules/zoxide.nix
    ../../homeManagerModules/zsh.nix
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
