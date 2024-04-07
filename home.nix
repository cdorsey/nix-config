{ config, pkgs, rootDir, nix-colors, ... }:
let
  inherit (nix-colors.lib-contrib { inherit pkgs; }) vimThemeFromScheme;
  inherit (nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
  inherit (nix-colors.lib-contrib { inherit pkgs; }) textMateThemeFromScheme;
in {
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    poetry
  ];

  colorScheme = nix-colors.colorSchemes.material-lighter;

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;

      theme = "custom";
      custom = "${rootDir}/oh-my-zsh";
      plugins = ["git" "node" "docker-compose"];
    };

    shellAliases = {
      cat = "bat -pp";
      ls = "exa";
      http = "xh";
      https = "xh -s";
    };

    initExtraFirst = ''
     . ${shellThemeFromScheme { scheme = config.colorScheme; }}
    '';
  };

  programs.vim = {
    enable = true;

    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-surround
      vim-nix
      vim-airline
      vim-airline-themes
      (vimThemeFromScheme { scheme = config.colorScheme; })
    ];

    extraConfig = ''
      colorscheme nix-${config.colorScheme.slug}

      let g:airline_theme='base16'
    '';
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
          white = "#${base07}";
          red = "#${base08}";
          orange = "#${base09}";
          yellow = "#${base0A}";
          green = "#${base0B}";
          blue = "#${base0C}";
          cyan = "#${base0D}";
          magenta = "#${base0E}";
        };
      };

      mouse_mode = true;
    };
  };

  programs.fzf = {
    enable = true;

    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;

    enableZshIntegration = true;
    options = ["--cmd" "cd"];
  };

  programs.bat = {
    enable = true;

    config.theme = "default";
    themes.default.src = textMateThemeFromScheme { scheme = config.colorScheme; };
  };

  home.file = {
    ".cargo/config.toml".text = ''
      [build]
      rustc-wrapper = "/run/current-system/sw/bin/sccache"
    '';
  };

  xdg.configFile = {
    "pypoetry/config.toml".text = ''
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
