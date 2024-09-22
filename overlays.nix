{ inputs, config, ... }:
with inputs;
[
  rust-overlay.overlays.default
  # hyprland.overlays.default
  (final: prev: { agenix = agenix.packages.${prev.system}.default; })
  (final: prev: { zjstatus = zjstatus.packages.${prev.system}.default; })
  (final: prev: { nil = nil.packages.${prev.system}.default; })
  # (final: prev: {
  #   hyprland = hyprland.packages.${prev.system}.hyprland.override { withSystemd = true; };
  # })
  (final: prev: { nerdfonts = prev.nerdfonts.override { fonts = [ "FiraCode" ]; }; })
  (final: prev: {
    scripts.deploy-atlas = import ./scripts/deploy-atlas.nix {
      pkgs = final;
      inherit config;
    };
  })
]
