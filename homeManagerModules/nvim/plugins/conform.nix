{ ... }:
{
  programs.nixvim.plugins.conform-nvim = {
    enable = true;

    formattersByFt = {
      nix = [ "nixfmt" ];
      python = [ "ruff" ];
      typescript = [ "prettier" ];
      javascript = [ "prettier" ];
      css = [ "prettier" ];
      json = [ "prettier" ];
      md = [ "prettier" ];
    };

    formatOnSave = { };
  };

}
