# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:
let
  nixosSwitch = pkgs.writeScriptBin "nixos-switch" ''
    if [[ $PWD != ~/.dotfiles ]]; then
      exit 0
    fi

    git diff --quiet --ignore-all-space -- home.nix
    if [[ $? -ne 0 ]]; then
      home-manager switch --flake .
      git add home.nix
      git commit -m "$(home-manager generations | head -n1)"
    fi

    git diff --quiet --ignore-all-space -- *.nix
    if [[ $? -ne 0 ]]; then
      sudo nixos-rebuild switch --flake .
      git add *.nix
      git commit -m "$(nixos-rebuild list-generations 2>/dev/null | grep current)"
    fi
  '';
in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [

    ];
  };

  environment = {
    systemPackages = with pkgs; [
      nixosSwitch

      wget
      vim-full
      rustup
      bun
      python3
      xh
      bat
      eza
      ripgrep
      fzf
      zoxide
      zellij
      sccache
      jq
      yq
    ];
  };

  programs.zsh.enable = true;

  services.vscode-server.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
  };

  time.timeZone = "US/Central";

  system.stateVersion = "23.11";
}
