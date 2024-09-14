{ inputs, config, }:
with inputs;
[
  (import inputs.rust-overlay)
  # hyprland.overlays.default
  # (final: prev: { zjstatus = zjstatus.packages.${prev.system}.default; })
  (final: prev: { nil = nil.packages.${prev.system}.default; })
  # (final: prev: {
  #   hyprland = hyprland.packages.${prev.system}.hyprland.override { withSystemd = true; };
  # })
  # (final: prev: { wezterm = wezterm.packages.${prev.system}.default; })
  (final: prev: { nerdfonts = prev.nerdfonts.override { fonts = [ "FiraCode" ]; }; })
  (final: prev: { scripts.deploy-atlas = import ./scripts/deploy-atlas.nix { pkgs = final; inherit config; }; })
]
