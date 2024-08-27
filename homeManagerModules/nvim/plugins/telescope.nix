{ ... }:
{
  programs.nixvim.plugins.telescope = {
    enable = true;

    keymaps = {
      "<leader>ff" = "find_files";
      "<leader>fg" = "live_grep";
      "<leader>fb" = "buffers";
      "<leader>fs" = "lsp_workspace_symbols";
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
}
