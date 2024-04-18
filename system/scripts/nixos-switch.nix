{ pkgs, ... }:
let
  git = "${pkgs.git}/bin/git";
  nixfmt = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
  nh = "${pkgs.nh}/bin/nh";
in
pkgs.writeShellScriptBin "nixos-switch" ''
  set -e

  # I'm lazy, so if we're not in the right directory, just bail
  if [[ $PWD != ~/.dotfiles ]]; then
    exit 0
  fi

  ${nixfmt} $(${git} ls-files -m | grep '\.nix$')

  # Update the system config if needed
  if ! ${git} diff --quiet --ignore-all-space -- flake.nix system/**/*.nix; then
    ${nh} os switch
    ${git} add flake.* system/**/*.nix
    ${git} commit -m "$(nixos-rebuild list-generations 2>/dev/null | grep current)"
  fi

  # Update the user config if needed
  if ! ${git} diff --quiet --ignore-all-space -- user/**/*.nix; then
    ${nh} home switch
    ${git} add user/**/*.nix
    ${git} commit -m "$(home-manager generations | head -n1)"
  fi
    # If there are remaining changed files, amend them to the last commit
  if ! ${git} diff --quiet --ignore-all-space; then
    ${git} commit --verbose --all --no-edit --amend
  fi
''
