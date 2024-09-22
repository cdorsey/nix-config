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
      sources = map (name: { inherit name; }) [
        "supermaven"
        "nvim_lsp"
        "luasnip"
        "path"
        "buffer"
      ];
      snippet.expand = # lua
        ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
      window = {
        completion = {
          border = "rounded";
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
        };
        documentation = {
          border = "rounded";
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
        };
      };
      mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<CR>" = "cmp.mapping.confirm({ select = false })";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      };
    };
  };
}
