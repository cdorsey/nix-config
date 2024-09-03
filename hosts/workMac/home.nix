{ nix-colors, inputs, ... }:
{
  imports = [
    nix-colors.homeManagerModules.default
    ../../homeManagerModules/bat.nix
    ../../homeManagerModules/zsh.nix
    ../../homeManagerModules/git.nix
    ../../homeManagerModules/cargo.nix
    ../../homeManagerModules/fzf.nix
    ../../homeManagerModules/zellij.nix
    ../../homeManagerModules/zoxide.nix
    ../../homeManagerModules/vim.nix
  ];

  colorScheme = nix-colors.colorSchemes.material-darker;

  userConfig = {
    git = {
      userEmail = inputs.work-values.email;
      userName = inputs.work-values.name;
    };

    zsh.plugins = [ "yarn" ];
  };

  programs.direnv = {
    enable = true;

    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
}
