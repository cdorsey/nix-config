{ config, lib, ... }:
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

    options = {
      showmode = false;
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 4;
      cursorline = true;
      termguicolors = true;
      backspace = "indent,eol,start";
      showmatch = true;
      listchars = "tab:→ ,space:·,nbsp:␣,eol:¶";
    };

    keymaps = [
      {
        action = "<CMD>Oil<CR>";
        key = "-";
        mode = "n";
        options.desc = "Open parent directory";
      }
      {
        action = "<CMD>Trouble diagnostics toggle filter.buf=0<CR>";
        key = "<leader>xx";
        mode = "n";
        options.desc = "Diagnostics (Trouble)";
      }
      {
        action = "<C-w>v<C-w>l";
        key = "<leader>wn";
        mode = "n";
      }
      {
        action = "<C-w>c";
        key = "<leader>wx";
        mode = "n";
      }
      {
        action = "<C-w>h";
        key = "<leader>wh";
        mode = "n";
      }
      {
        action = "<C-w>j";
        key = "<leader>wj";
        mode = "n";
      }
      {
        action = "<C-w>k";
        key = "<leader>wk";
        mode = "n";
      }
      {
        action = "<C-w>l";
        key = "<leader>wl";
        mode = "n";
      }
      {
        action = "<CMD>tabNext<CR>";
        key = "<leader>tl";
        mode = "n";
      }
      {
        action = "<CMD>tabprevious<CR>";
        key = "<leader>th";
        mode = "n";
      }
      {
        action = "<CMD>tabclose<CR>";
        key = "<leader>tx";
        mode = "n";
      }
      {
        action = "<CMD>tabnew<CR>";
        key = "<leader>tn";
        mode = "n";
      }
    ];

    colorschemes.tokyonight = {
      enable = true;

      settings = {
        style = "night";
      };
    };

    plugins.trouble = {
      enable = true;

      settings = {
        auto_close = true;
      };
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
        nil_ls = {
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
        rust-analyzer.enable = true;
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
          "<C-Space>" = ''cmp.mapping.complete()'';
          "<CR>" = ''cmp.mapping.confirm({ select = true })'';
          "<S-Tab>" = ''cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})'';
          "<Tab>" = ''cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})'';
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
              for _, hidden in ipairs({'.git', '.jj', 'node_modules', '.venv'}) do
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
        "<leader>fh" = "help_tags";
        "<leader>fd" = "lsp_definitions";
        "<leader>fr" = "lsp_references";
      };
    };

    plugins.none-ls = {
      enable = true;
    };
  };
}
