{ ... }:
{
  programs.nixvim.plugins.cmp = {
    enable = true;

    autoEnableSources = true;
    cmdline = {
      "/" = {
        mapping.__raw = "cmp.mapping.preset.cmdline()";
        sources = [ { name = "buffer"; } ];
      };
      ":" = {
        mapping.__raw = "cmp.mapping.preset.cmdline()";
        sources = [
          { name = "path"; }
          {
            name = "cmdline";
            option = {
              ignore_cmds = [
                "Man"
                "!"
              ];
            };
          }
        ];
      };
    };

    settings = {
      sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
      snippet.expand = # lua
        ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
      mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      };
    };
  };
}
