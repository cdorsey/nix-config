{ config, pkgs, rootDir, ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    poetry
  ];

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

      nixos-test = "nixos-rebuild test --flake ~/.dotfiles";
      nixos-switch = "nixos-rebuild switch --flake ~/.dotfiles";
      hm-switch = "home-manager switch --flake ~/.dotfiles";
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

      themes = {
        tokyo-night = {
          fg = [ 169 177 214 ];
          bg = [ 26 27 38 ];
          black = [ 56 62 90 ];
          red = [ 249 51 87 ];
          green = [ 158 206 106 ];
          yellow = [ 224 175 104 ];
          blue = [ 122 162 247 ];
          magenta = [ 187 154 247 ];
          cyan = [ 42 195 222 ];
          white = [ 192 202 245 ];
          orange = [ 255 158 100 ];
        };
      };
      theme = "tokyo-night";
      mouse_mode = false;
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
