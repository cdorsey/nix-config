{ inputs, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
}
