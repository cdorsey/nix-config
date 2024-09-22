{ ... }:
{
  imports = [
    ./auto-session.nix
    ./cmp.nix
    ./conform.nix
    # ./copilot.nix
    ./harpoon.nix
    ./lsp.nix
    ./lspkind.nix
    ./oil.nix
    ./supermaven.nix
    ./telescope.nix
    ./treesitter.nix
  ];

  programs.nixvim = {
    plugins.nvim-colorizer = {
      enable = true;

      userDefaultOptions = {
        mode = "virtualtext";
      };
    };

    plugins.lazygit = {
      enable = true;

      settings = {
        floating_window_use_plenary = 1;
      };
    };

    plugins.trouble = {
      enable = true;

      settings = {
        auto_close = true;
      };
    };

    plugins.which-key = {
      enable = true;
      settings = {
        preset = "helix";
      };
    };

    plugins.friendly-snippets = {
      enable = true;
    };

    plugins.vim-surround = {
      enable = true;
    };

    plugins.indent-o-matic = {
      enable = true;
    };

    plugins.lualine = {
      enable = true;
    };

    plugins.bufferline = {
      enable = true;
    };

    plugins.luasnip = {
      enable = true;
    };

    plugins.comment = {
      enable = true;
    };

    plugins.nvim-autopairs = {
      enable = true;

      settings = {
        check_ts = true;
      };
    };

    plugins.gitsigns = {
      enable = true;
    };

    plugins.crates-nvim = {
      enable = true;
    };

    plugins.indent-blankline = {
      enable = true;

      settings = {
        indent.char = "│";
      };
    };
  };
}
