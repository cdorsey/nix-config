{ config, lib, ... }:
{
  programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
    vim = "nvim";
    vi = "nvim";
  };

  programs.nixvim = {
    enable = true;

    defaultEditor = true;

    globals = {
      mapleader = " ";
    };

    options = {
      showmode = false;
      number = true;
      expandtab = true;
      shiftwidth = 4;
      cursorline = true;
    };

    keymaps = [
      {
        action = "<CMD>Oil<CR>";
        key = "-";
        mode = "n";
        options.desc = "Open parent directory";
      }
    ];

    colorschemes.tokyonight = {
      enable = true;

      settings = {
        style = "night";
      };
    };

    plugins.lualine = {
      enable = true;
    };

    plugins.bufferline = {
      enable = true;
    };

    plugins.luasnip = {
      enable = true;

      extraConfig = {
        run = "make install_jsregexp";
      };
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
          mapping = {
            __raw = # lua
              "cmp.mapping.preset.cmdline()";
          };
          sources = [ { name = "buffer"; } ];
        };
        ":" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
          };
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
              require('luascript').lsp_expand(args.body)
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
          is_hidden_file.__raw = # lua
            ''
              function(name, _)
                for _, hidden in ipairs({'.git', '.jj'}) do
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

      filetypes = {
        nix = false;
      };
    };

    plugins.treesitter = {
      enable = true;

      indent = true;
      nixvimInjections = true;
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
