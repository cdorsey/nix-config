{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [ vim bat ];

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
