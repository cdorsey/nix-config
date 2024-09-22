{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [
      pkgs.vimPlugins.supermaven-nvim
    ];

    extraConfigLua = # lua
      ''
        require("supermaven-nvim").setup({
          log_level = "off",
          disable_inline_completion = true,
        })
      '';
  };
}
