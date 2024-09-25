{
  lib,
  config,
  pkgs,
  nix-colors,
  ...
}:
with lib;
let
  inherit (nix-colors.lib-contrib { inherit pkgs; }) vimThemeFromScheme;
  cfg = config.userConfig.vim;
in
{
  options.userConfig.vim = {
    plugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };
  };

  config.programs.vim = {
    enable = true;

    defaultEditor = true;
    plugins =
      with pkgs.vimPlugins;
      [
        vim-surround
        vim-nix
        vim-airline
        vim-airline-themes
        (vimThemeFromScheme { scheme = config.colorScheme; })
      ]
      ++ cfg.plugins;

    extraConfig = ''
      colorscheme nix-${config.colorScheme.slug}

      set noshowmode
      let g:airline_theme='base16'
    '';
  };
}
