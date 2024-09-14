{ inputs, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
}
