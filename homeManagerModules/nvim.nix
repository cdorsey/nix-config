{
  config,
  pkgs,
  nix-colors,
  ...
}:
let
  inherit (nix-colors.lib-contrib { inherit pkgs; }) vimThemeFromScheme;
  mkPlugin = plg: cfg: {
    plugin = plg;
    type = "lua";
    config = cfg;
  };
in
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = # lua
      ''
        vim.g.mapleader = " "

        vim.opt.showmode = false
        vim.opt.number = true
        vim.opt.expandtab = true

        local keys =
        	{ "n", "q", "h", "j", "k", "l", "s", "v", "^", "c", "o", "r", "R", "x", "X", "<Left>", "<Right>", "<Up>", "<Down>" }

        for i, key in ipairs(keys) do
        	vim.keymap.set("n", "<leader>w" .. key, "<C-w>" .. key, {})
        end
      
'';

    extraPackages =
      with pkgs;
      [
        typescript
        ruff
        ruff-lsp
        stylua
        nil
        shfmt
        tree-sitter
        pyright
      ]
      ++ (with nodePackages; [
        typescript-language-server
        volar
      ]);

    plugins = with pkgs.vimPlugins; [
      vim-airline-themes
      neo-tree-nvim
      vim-nix
      plenary-nvim
      cmp-path
      cmp-nvim-lsp
      cmp-buffer
      cmp-cmdline
      cmp-vsnip
      cmp-git
      (mkPlugin actions-preview-nvim # lua
        ''
          local actions_preview = require("actions-preview")

          vim.keymap.set({ "v", "n" }, "<M-CR>", actions_preview.code_actions, {})

          actions_preview.setup({
          	backend = { "telescope" },
          })
        ''
      )
      (mkPlugin hover-nvim # lua
        ''
          local hover = require("hover")

          hover.setup({
          	init = function()
          		require("hover.providers.lsp")
          	end,
          	preview_opts = {
          		border = "single",
          	},
          	preview_window = true,
          	mouse_providers = { "LSP" },
          	mouse_delay = 1000,
          })

          vim.keymap.set("n", "K", hover.hover, { desc = "hover.nvim" })
          vim.keymap.set("n", "gK", hover.hover_select, { desc = "hover.nvim (select)" })
          vim.keymap.set("n", "<C-p>", function()
          	hover.hover_switch("previous")
          end, { desc = "hover.nvim (previous source)" })
          vim.keymap.set("n", "<C-n>", function()
          	hover.hover_switch("next")
          end, { desc = "hover.nvim (next source)" })

          -- Mouse support
          vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
          vim.o.mousemoveevent = true
        ''
      )
      (mkPlugin oil-nvim # lua
        ''
          vim.keymap.set("n", "-", "<CMD>Oil<CR>")

          require("oil").setup({
          	default_file_explorer = true,
          	view_options = {
          		show_hidden = true,
          	},
          })
        ''
      )
      (mkPlugin bufferline-nvim # lua
        ''
          vim.opt.termguicolors = true

          require("bufferline").setup()
        ''
      )
      (mkPlugin conform-nvim # lua
        ''
          require("conform").setup({
          	formatters_by_ft = {
          		nix = { "nixfmt", "injected" },
          		python = { "ruff" },
          		lua = { "stylua" },
          		bash = { "shfmt" },
          	},
          	format_on_save = {
          		timeout_ms = 500,
          		lsp_fallback = true,
          	},
          })
        ''
      )
      (mkPlugin comment-nvim # lua
        ''
          require("Comment").setup()
        ''
      )
      (mkPlugin nvim-autopairs # lua
        ''
          require("nvim-autopairs").setup()
        ''
      )
      (mkPlugin gitsigns-nvim # lua
        ''
          require("gitsigns").setup()
        ''
      )
      (mkPlugin crates-nvim # lua
        ''
          require("crates").setup()
        ''
      )
      (mkPlugin indent-blankline-nvim # lua
        ''
          local highlight = {
          	"CursorColumn",
          	"Whitespace",
          }
          require("ibl").setup({
          	indent = { char = "│" },
          })
        ''
      )
      (mkPlugin copilot-vim # lua
        ''
          vim.g.copilot_filetypes = {
          	nix = false,
          }
        ''
      )
      (mkPlugin tokyonight-nvim # lua
        ''vim.cmd([[colorscheme tokyonight-night]])''
      )
      (mkPlugin nvim-lspconfig # lua
        ''
          local lspconfig = require('lspconfig')
          local capabilities = require('cmp_nvim_lsp').default_capabilities()

          lspconfig.nil_ls.setup({
            autostart = true,
            capabilities = capabilities,
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
            capabilities = capabilities,
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

          lspconfig.volar.setup{
            capabilities = capabilities,
          }

          lspconfig.ruff.setup{
            capabilities = capabilities,
          }

          lspconfig.ruff_lsp.setup{
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              if client.name == 'ruff_lsp' then
                client.server_capabilities.hoverProvider = false
              end
            end
          }
           
          lspconfig.pyright.setup{
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              client.resolved_capabilities.hover = true
            end,
            settings = {
              pyright = {
                disableOrganizeImports = true,
              },
              python = {
                analysis = {
                  ignore = { '*' }
                },
              },
            },
          }

          lspconfig.lua_ls.setup{
            capabilities = capabilities,
          }

          lspconfig.rust_analyzer.setup{
            capabilities = capabilities,
            settings = {
              ['rust-analyzer'] = {
                diagnostics = {
                  enable = false;
                }
              }
            }
          }
        ''
      )
      (mkPlugin nvim-cmp # lua
        ''
          local cmp = require("cmp")
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
          		completion = cmp.config.window.bordered(),
          		documentation = cmp.config.window.bordered(),
          	},
          	mapping = cmp.mapping.preset.insert({
          		["<C-b>"] = cmp.mapping.scroll_docs(-4),
          		["<C-f>"] = cmp.mapping.scroll_docs(4),
          		["<C-Space>"] = cmp.mapping.complete(),
          		["<C-e>"] = cmp.mapping.abort(),
          		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          		["<Tab>"] = cmp.mapping.confirm({ select = true }),
          	}),
          	sources = cmp.config.sources({
          		{ name = "nvim_lsp" },
          		{ name = "vsnip" }, -- For vsnip users.
          	}, {
          		{ name = "buffer" },
          	}),
          })

          cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

          -- Set configuration for specific filetype.
          cmp.setup.filetype("gitcommit", {
          	sources = cmp.config.sources({
          		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
          	}, {
          		{ name = "buffer" },
          	}),
          })

          -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline({ "/", "?" }, {
          	mapping = cmp.mapping.preset.cmdline(),
          	sources = {
          		{ name = "buffer" },
          	},
          })

          -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline(":", {
          	mapping = cmp.mapping.preset.cmdline(),
          	sources = cmp.config.sources({
          		{ name = "path" },
          	}, {
          		{ name = "cmdline" },
          	}),
          })
        ''
      )
      (mkPlugin nvim-treesitter.withAllGrammars # lua
        ''
          require("nvim-treesitter.configs").setup({
          	highlight = { enable = true },
          	indent = { enable = true },
          })

          require("vim.treesitter.query").set(
          	"nix",
          	"injections",
          	[[
          ; #-style Comments
          ((comment) @injection.language
          . ; this is to make sure only adjacent comments are accounted for the injections
          [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
          ]
          (#gsub! @injection.language "#%s*([%w%p]+)%s*" "%1")
          (#set! injection.combined))
          ]]
          )
        ''
      )
      (mkPlugin nvim-web-devicons # lua
        ''
          require("nvim-web-devicons").setup()
        ''
      )
      (mkPlugin telescope-nvim # lua
        ''
          local builtin = require("telescope.builtin")

          vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
          vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
          vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
          vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
          vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, {})
          vim.keymap.set("n", "<leader>fr", builtin.lsp_references, {})
          require("telescope").setup()
        ''
      )
      (mkPlugin vim-airline # lua
        ''
          vim.g.airline_theme = "base16"
        ''
      )
      (vimThemeFromScheme { scheme = config.colorScheme; })
    ];
  };
}
