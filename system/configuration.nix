# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/var/secrets/age/keys.txt";

    secrets = { hello = { }; };
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs;
      [

      ];
  };

  environment = {
    systemPackages = with pkgs;
      [
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
        nixfmt
      ] ++ [ (import ./scripts/nixos-switch.nix { inherit pkgs; }) ];
  };

  programs.zsh.enable = true;

  services.vscode-server.enable = true;

  users = { defaultUserShell = pkgs.zsh; };

  time.timeZone = "US/Central";

  system.stateVersion = "23.11";
}
