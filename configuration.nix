# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:
let
  nixosSwitch = pkgs.writeScriptBin "nixos-switch" ''
    set -e

    GIT=${pkgs.git}/bin/git

    # I'm lazy, so if we're not in the right directory, just bail
    if [[ $PWD != ~/.dotfiles ]]; then
      exit 0
    fi

    # Update the user config if needed
    if ! $GIT diff --quiet --ignore-all-space -- home.nix; then
      home-manager switch --flake .
      $GIT add home.nix
      $GIT commit -m "$(home-manager generations | head -n1)"
    fi

    # Update the system config if needed
    if ! $GIT diff --quiet --ignore-all-space -- *.nix; then
      sudo nixos-rebuild switch --flake .
      $GIT add *.nix
      $GIT commit -m "$(nixos-rebuild list-generations 2>/dev/null | grep current)"
    fi

    # If there are remaining changed files, amend them to the last commit
    if ! $GIT diff --quiet --ignore-all-space; then
      $GIT commit --verbose --all --no-edit --amend
    fi
  '';
in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/var/secrets/age/keys.txt";

    secrets = {
      hello = {};
    };
  };

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
      sops
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
