{ inputs }:
with inputs;
[
  rust-overlay.overlays.default
  # hyprland.overlays.default
  # (final: prev: { zjstatus = zjstatus.packages.${prev.system}.default; })
  (final: prev: { nil = nil.packages.${prev.system}.default; })
  # (final: prev: {
  #   hyprland = hyprland.packages.${prev.system}.hyprland.override { withSystemd = true; };
  # })
  (final: prev: { wezterm = wezterm.packages.${prev.system}.default; })
  (final: prev: { nerdfonts = prev.nerdfonts.override { fonts = [ "FiraCode" ]; }; })
]
