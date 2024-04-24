{ config, pkgs, nix-colors, ... }: 
let 
  inherit (nix-colors.lib-contrib { inherit pkgs; }) vimThemeFromScheme;
in {
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = ''
      colorscheme nix-${config.colorScheme.slug}

      set noshowmode
      set mouse=
      :set number
      :set expandtab
    '';

    extraPackages= with pkgs; [
      typescript
      ruff
    ] ++ (with nodePackages; [
      typescript-language-server
      pyright
      volar
    ]);

    plugins = with pkgs.vimPlugins; [
      vim-airline-themes
      neo-tree-nvim
      vim-nix
      gitgutter
      crates-nvim
      plenary-nvim
      cmp-path
      cmp-nvim-lsp
      cmp-buffer
      cmp-cmdline
      cmp-vsnip
      cmp-git
      {
        plugin = copilot-vim;
        config = ''
          let g:copilot_filetypes = {
          \  'nix': v:false,
          \}
        '';
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local lspconfig = require('lspconfig')

          lspconfig.nil_ls.setup({
            autostart = true,
            settings = {
              ['nil'] = {
                formatting = {
                  command = { "nixpkgs-fmt" },
                },
              },
            },
            cmd = { "${pkgs.nil}/bin/nil" }
          })

          lspconfig.tsserver.setup{
            init_options = {
              plugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = "${pkgs.typescript}",
                  languages = {"javascript", "typescript", "vue"},
                },
              },
            },
            filetypes = {
              "javascript",
              "typescript",
              "vue",
            },
          }

          lspconfig.volar.setup{}

          lspconfig.ruff.setup{}

          lspconfig.pyright.setup{}

          lspconfig.rust_analyzer.setup{
            settings = {
              ['rust-analyzer'] = {
                diagnostics = {
                  enable = false;
                }
              }
            }
          }
        '';
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require'cmp'
          cmp.setup({
            snippet = {
              -- REQUIRED - you must specify a snippet engine
              expand = function(args)
                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
              end,
            },
            window = {
              -- completion = cmp.config.window.bordered(),
              -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
              ['<Tab>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'vsnip' }, -- For vsnip users.
              -- { name = 'luasnip' }, -- For luasnip users.
              -- { name = 'ultisnips' }, -- For ultisnips users.
              -- { name = 'snippy' }, -- For snippy users.
            }, {
              { name = 'buffer' },
            })
          })

          -- Set configuration for specific filetype.
          cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
              { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
            }, {
              { name = 'buffer' },
            })
          })

          -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = 'buffer' }
            }
          })

          -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            })
          })

          -- Set up lspconfig.
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
        '';
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
            highlight = { enable = true }
          }
        '';
      }
      { 
        plugin = nvim-web-devicons;
        type = "lua";
        config = ''
          require("nvim-web-devicons").setup {}
        '';
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local builtin = require('telescope.builtin')

          vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
          vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
          vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, {})
          vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
          require("telescope").setup{}
        '';
      }
      (vimThemeFromScheme { scheme = config.colorScheme; })
      {
        plugin = vim-airline;
        config = ''
          let g:airline_theme='base16'
        '';
      }
    ];
  };
}
