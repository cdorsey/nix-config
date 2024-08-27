{ ... }:
{
  programs.nixvim.plugins.copilot-lua = {
    enable = true;

    suggestion = {
      autoTrigger = true;
    };

    filetypes = {
      nix = false;
      oil = false;
    };
  };
}
