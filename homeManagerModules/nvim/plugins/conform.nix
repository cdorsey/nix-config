{ ... }:
{
  programs.nixvim.plugins.conform-nvim = {
    enable = true;

    settings = {
      formatters_by_ft = {
        nix = [ "nixfmt" ];
        python = [ "ruff" ];
        typescript = [ "prettier" ];
        javascript = [ "prettier" ];
        css = [ "prettier" ];
        json = [ "prettier" ];
        md = [ "prettier" ];
      };
      format_on_save = {
        lsp_fallback = true;
      };
    };

  };

}
