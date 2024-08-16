{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    eza
    ripgrep
    yq
    jq
    nixfmt-rfc-style
    nil
    just
    xh
    uv
    bottom
    poetry
    nodejs_20
  ];

  users.users.cdorsey = {
    shell = pkgs.zsh;
    home = "/Users/cdorsey";
  };

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;

  documentation.enable = false;

  services.nix-daemon.enable = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 4;
}
