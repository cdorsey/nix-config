{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim.plugins.lsp = {
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
      ts-ls = {
        enable = true;

        extraOptions = {
          init_options = {
            plugins = [
              {
                name = "@vue/typescript-plugin";
                location = "${config.programs.nixvim.plugins.lsp.servers.volar.package}";
                languages = [ "vue" ];
              }
            ];
          };
          commands = {
            OrganizeImports.__raw = ''
              {
                function()
                  local params = {
                    command = "_typescript.organizeImports",
                    arguments = {vim.api.nvim_buf_get_name(0)},
                    title = ""
                  }

                  vim.lsp.buf.execute_command(params)
                end,
                description = "Organize Imports"
              }
            '';
          };
        };
      };

      volar = {
        enable = true;

        extraOptions = {
          init_options = {
            vue.hybridMode = false;
          };
        };
      };

      cssls.enable = true;
    };
  };
}
