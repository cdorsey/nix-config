{ config, pkgs, rootDir, nix-colors, ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    poetry
  ];

  colorScheme = nix-colors.colorSchemes.tokyo-night-terminal-dark;

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;

      theme = "custom";
      custom = "${rootDir}/oh-my-zsh";
      plugins = ["git" "node" "docker" "docker-compose"];
    };

    shellAliases = {
      cat = "bat -pp";
      ls = "exa";
      http = "xh";
      https = "xh -s";

      # nixos-test = "sudo nixos-rebuild test --flake ~/.dotfiles";
      # nixos-switch = "sudo nixos-rebuild switch --flake ~/.dotfiles";
      # hm-switch = "home-manager switch --flake ~/.dotfiles";

      #docker = "/run/current-system/sw/bin/docker";
    };
  };

  programs.vim = {
    enable = true;

    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-surround
    ];
  };

  programs.git = {
    enable = true;

    userEmail = "git@chase-dorsey.com";
    userName = "Chase Dorsey";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.zellij = {
    enable = true;

    enableZshIntegration = true;
    settings = {
      plugins = {
        tab-bar = { path = "tab-bar"; };
        status-bar = { path = "status-bar"; };
        strider = { path = "strider"; };
        compact-bar = { path = "compact-bar"; };
      };

      pane_frames = false;

      themes = with config.colorScheme.palette; {
        default = {
          fg = "#${base06}";
          bg = "#${base00}";
          black = "#${base00}";
          white = "#${base08}";
          red = "#${base09}";
          orange = "#${base0A}";
          yellow = "#${base0B}";
          green = "#${base0C}";
          blue = "#${base0D}";
          cyan = "#${base0E}";
          magenta = "#${base0F}";
        };
      };

      mouse_mode = true;
    };
  };

  programs.zoxide = {
    enable = true;

    enableZshIntegration = true;
    options = ["--cmd" "cd"];
  };

  home.file = {
    ".cargo/config.toml".text = ''
      [build]
      rustc-wrapper = "/run/current-system/sw/bin/sccache"
    '';

    "${config.xdg.configHome}/pypoetry/config.toml".text = ''
      [virtualenvs]
      in-project = true
    '';
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
