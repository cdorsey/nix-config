{ config, lib, ... }:
let
  nmap = key: action: options: {
    key = key;
    action = action;
    mode = "n";
    options = options;
  };
in
{
  programs.nixvim = {
    enable = true;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    diagnostics = {
      virtual_text = false;
    };

    globals = {
      mapleader = " ";
    };

    opts = {
      showmode = false;
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 4;
      tabstop = 4;
      softtabstop = 4;
      smarttab = true;
      cursorline = true;
      termguicolors = true;
      backspace = "indent,eol,start";
      showmatch = true;
      listchars = "tab:→ ,space:·,nbsp:␣,eol:¶";
    };

    keymaps = [
      (nmap "-" "<CMD>Oil<CR>" { desc = "Open parent directory"; })
      (nmap "<leader>xx" "<CMD>Trouble diagnostics toggle filter.buf=0<CR>" {
        desc = "Open diagnostics (current buffer)";
      })
      (nmap "<leader>wn" "<C-w>v<C-w>l" { desc = "New window (vertical split)"; })
      (nmap "<leader>wx" "<C-w>q" { desc = "Close focused window"; })
      (nmap "<leader>wX" "<C-w>o" { desc = "Close other windows"; })
      (nmap "<leader>wh" "<C-w>h" { desc = "Move to window left"; })
      (nmap "<leader>wj" "<C-w>j" { desc = "Move to window down"; })
      (nmap "<leader>wk" "<C-w>k" { desc = "Move to window up"; })
      (nmap "<leader>wl" "<C-w>l" { desc = "Move to window right"; })
      (nmap "<leader>w=" "<C-w>=" { desc = "Equally distribute windows"; })
      (nmap "<leader>tl" "<CMD>tabNext<CR>" { desc = "Switch to next tab"; })
      (nmap "<leader>th" "<CMD>tabprevious<CR>" { desc = "Move to previous tab"; })
      (nmap "<leader>tx" "<CMD>tabclose<CR>" { desc = "Close current tab"; })
      (nmap "<leader>tn" "<CMD>tabnew<CR>" { desc = "Open a new tab"; })
    ];

    colorschemes.tokyonight = {
      enable = true;

      settings = {
        style = "night";
      };
    };

    plugins.nvim-colorizer = {
      enable = true;

      userDefaultOptions = {
        mode = "virtualtext";
      };
    };

    plugins.lazygit = {
      enable = true;

      settings = {
        floating_window_use_plenary = true;
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

    plugins.surround = {
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

    plugins.lsp = {
      enable = true;
      servers = {
        docker-compose-language-service.enable = true;
        dockerls.enable = true;
        nil-ls = {
          enable = true;
          autostart = true;
        };
        pyright = {
          enable = true;

          settings = {
            pyright.disableOrganizeImports = true;
            python.analysis.ignore = [ "*" ];
          };
        };
        ruff-lsp.enable = true;
        rust-analyzer = {
          enable = true;
          installRustc = false;
          installCargo = false;
        };
        tailwindcss.enable = true;
        tsserver.enable = true;
        volar.enable = true;
      };
    };

    plugins.cmp = {
      enable = true;

      autoEnableSources = true;
      cmdline = {
        "/" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [ { name = "buffer"; } ];
        };
        ":" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [
            { name = "path"; }
            {
              name = "cmdline";
              option = {
                ignore_cmds = [
                  "Man"
                  "!"
                ];
              };
            }
          ];
        };
      };

      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        snippet.expand = # lua
          ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
      };
    };

    plugins.conform-nvim = {
      enable = true;

      formattersByFt = {
        nix = [ "nixfmt" ];
        python = [ "ruff" ];
        typescript = [ "prettier" ];
        javascript = [ "prettier" ];
      };

      formatOnSave = { };
    };

    plugins.oil = {
      enable = true;

      settings = {
        default_file_explorer = true;
        use_default_keymaps = true;
        view_options = {
          is_hidden_file.__raw = ''
            function(name, _)
            for _, hidden in ipairs({'.git', '.jj', 'node_modules', '.venv', '.direnv'}) do
              if hidden == name then
                return true
              end
            end

            return false
            end
          '';

        };
        keymaps = {
          "q" = "actions.close";
        };
      };
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

    plugins.copilot-lua = {
      enable = true;

      suggestion = {
        autoTrigger = true;
      };

      filetypes = {
        nix = false;
        oil = false;
      };

    };

    plugins.treesitter = {
      enable = true;

      settings = {
        highlight.enable = true;
        indent.enable = true;
        nixvimInjections = true;
        auto_install = true;
      };
    };

    plugins.treesitter-refactor = {
      enable = true;

      smartRename.enable = true;
    };

    plugins.telescope = {
      enable = true;

      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>fs" = "treesitter";
        "<leader>fh" = "help_tags";
        "<leader>fd" = "lsp_definitions";
        "<leader>fr" = "lsp_references";
      };

      settings = {
        defaults = {
          file_ignore_patterns = [
            "^.git/"
            "^.mypy_cache/"
            "__pycache__/"
            "^output/"
            "^data/"
            "^build/"
            "^dist/"
            "node_modules"
            "%.ipynb"
          ];

          prompt_prefix = " ";
        };
      };
    };
  };
}
