{ ... }:
{
  programs.nixvim.plugins.lspkind = {
    enable = true;
    mode = "symbol";
    symbolMap = {
      Supermaven = "";
    };
    cmp = {
      enable = true;
    };
  };
}
