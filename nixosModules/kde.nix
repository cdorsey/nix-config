{
  ...
}:
{
  services.desktopManager.plasma6.enable = true;

  services.displayManager.defaultSession = "plasma";

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
}
