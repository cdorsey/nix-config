{ config, lib, ... }:
let
  nmap = key: action: options: {
    key = key;
    action = action;
    mode = "n";
    options = options;
  };
  imap = key: action: options: {
    key = key;
    action = action;
    mode = "i";
    options = options;
  };
in
{
  imports = [ ./plugins ];

  programs.nixvim = {
    enable = true;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    diagnostics = {
      virtual_text = false;
    };

    globals = {
      mapleader = " ";
    };

    opts = {
      showmode = false;
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 4;
      tabstop = 4;
      softtabstop = 4;
      smarttab = true;
      cursorline = true;
      termguicolors = true;
      backspace = "indent,eol,start";
      showmatch = true;
      listchars = "tab:→ ,space:·,nbsp:␣,eol:¶";
    };

    keymaps = [
      (nmap "-" "<CMD>Oil<CR>" { desc = "Open parent directory"; })
      (nmap "<leader>xx" "<CMD>Trouble diagnostics toggle filter.buf=0<CR>" {
        desc = "Open diagnostics (current buffer)";
      })
      (nmap "<leader>wn" "<C-w>v<C-w>l" { desc = "New window (vertical split)"; })
      (nmap "<leader>wx" "<C-w>q" { desc = "Close focused window"; })
      (nmap "<leader>wX" "<C-w>o" { desc = "Close other windows"; })
      (nmap "<leader>wh" "<C-w>h" { desc = "Move to window left"; })
      (nmap "<leader>wj" "<C-w>j" { desc = "Move to window down"; })
      (nmap "<leader>wk" "<C-w>k" { desc = "Move to window up"; })
      (nmap "<leader>wl" "<C-w>l" { desc = "Move to window right"; })
      (nmap "<leader>w=" "<C-w>=" { desc = "Equally distribute windows"; })
      (nmap "<leader>tl" "<CMD>tabNext<CR>" { desc = "Switch to next tab"; })
      (nmap "<leader>th" "<CMD>tabprevious<CR>" { desc = "Move to previous tab"; })
      (nmap "<leader>tx" "<CMD>tabclose<CR>" { desc = "Close current tab"; })
      (nmap "<leader>tn" "<CMD>tabnew<CR>" { desc = "Open a new tab"; })

      (imap "<M-CR>" { __raw = "vim.lsp.buf.code_action"; } { desc = "Open code actions"; })
    ];

    colorschemes.tokyonight = {
      enable = true;

      settings = {
        style = "night";
      };
    };
  };
}
