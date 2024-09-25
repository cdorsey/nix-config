{
  lib,
  colorScheme,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../homeManagerModules/bat.nix
    ../../homeManagerModules/cargo.nix
    ../../homeManagerModules/fzf.nix
    ../../homeManagerModules/git.nix
    ../../homeManagerModules/starship
    ../../homeManagerModules/vim.nix
    ../../homeManagerModules/zellij.nix
    ../../homeManagerModules/zoxide.nix
    ../../homeManagerModules/zsh.nix
  ];

  colorScheme = colorScheme;

  userConfig = {
    git = {
      userEmail = inputs.work-values.email;
      userName = inputs.work-values.name;
    };

    starship = {
      useNerdFont = false;
      disableModules = [ "docker_context" ];
    };

    zsh = {
      plugins = [ "yarn" ];
      shellAliases =
        let
          inherit (lib) getExe;
        in
        with pkgs;
        {
          gpsup = "${getExe git} push --set-upstream origin HEAD:cdd/$(git_current_branch)";
        };
    };
  };

  programs.direnv = {
    enable = true;

    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
}
