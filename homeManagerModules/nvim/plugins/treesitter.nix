{ ... }:
{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;

      settings = {
        highlight.enable = true;
        indent.enable = true;
        nixvimInjections = true;
        auto_install = true;
      };
    };

    plugins.treesitter-refactor = {
      enable = true;

      smartRename.enable = true;
    };
  };
}
