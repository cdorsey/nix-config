{ pkgs, ... }:
{
  programs.nixvim = {
  extraPlugins = [
      pkgs.vimPlugins.supermaven-nvim
  ];

  extraConfigLua = # lua 
  ''
    require("supermaven-nvim").setup({})
  '';
  };
}
