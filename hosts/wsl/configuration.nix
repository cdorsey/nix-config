# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  config,
  pkgs,
  root-dir,
  inputs,
  ...
}:
{
  imports = [
    inputs.vscode-server.nixosModules.default
    # inputs.sops-nix.nixosModules.sops
    (root-dir + /nixosModules/wsl.nix)
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # sops = {
  #   defaultSopsFile = root-dir + /secrets/secrets.yaml;
  #   defaultSopsFormat = "yaml";
  #
  #   age.keyFile = "/var/secrets/age/keys.txt";
  #
  #   secrets = {
  #     hello = { };
  #   };
  # };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [

    ];
  };

  programs.zsh.enable = true;

  # TODO This URI is broken
  # programs.nh = {
  #   enable = true;
  #   clean.enable = true;
  #   clean.extraArgs = "--keep-since 4d --keep 3";
  #
  #   flake = config.users.users.nixos.home + /.dotfiles;
  # };

  services.vscode-server.enable = true;

  environment = {
    systemPackages =
      with pkgs;
      [
        wget
        vim-full
        xh
        bat
        eza
        ripgrep
        fzf
        zoxide
        zellij
        jq
        yq
        sops
        nixfmt-rfc-style
        jujutsu
      ]
      ++ [ (import (root-dir + /scripts/nixos-switch.nix) { inherit pkgs; }) ];
  };

  users = {
    defaultUserShell = pkgs.zsh;
  };

  time.timeZone = "US/Central";

  system.stateVersion = "23.11";
}
