{ nix-colors, inputs, ...}: {
  imports = [
    nix-colors.homeManagerModules.default
    ../../homeManagerModules/bat.nix
    ../../homeManagerModules/zsh.nix
    ../../homeManagerModules/git.nix
    ../../homeManagerModules/cargo.nix
    ../../homeManagerModules/fzf.nix
    ../../homeManagerModules/zellij.nix
    ../../homeManagerModules/zoxide.nix
  ];

  colorScheme = nix-colors.colorSchemes.material-darker;

  userConfig = {
    git = {
      userEmail = "chase.dorsey@q2ebanking.com";
      userName = "Chase Dorsey";
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
}
