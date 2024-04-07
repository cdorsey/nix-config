{ pkgs, ... }:
let
  git = "${pkgs.git}/bin/git";
  nixfmt = "${pkgs.nixfmt}/bin/nixfmt";
in pkgs.writeShellScriptBin "nixos-switch" ''
  set -e

  # I'm lazy, so if we're not in the right directory, just bail
  if [[ $PWD != ~/.dotfiles ]]; then
    exit 0
  fi

  ${nixfmt} $(${git} ls-files -m -x *.nix)

  # Update the user config if needed
  if ! ${git} diff --quiet --ignore-all-space -- user/**/*.nix; then
    home-manager switch --flake .
    ${git} add user/**/*.nix
    ${git} commit -m "$(home-manager generations | head -n1)"
  fi

  # Update the system config if needed
  if ! ${git} diff --quiet --ignore-all-space -- system/**/*.nix; then
    sudo nixos-rebuild switch --flake .
    ${git} add system/**/*.nix
    ${git} commit -m "$(nixos-rebuild list-generations 2>/dev/null | grep current)"
  fi

    # If there are remaining changed files, amend them to the last commit
  if ! ${git} diff --quiet --ignore-all-space; then
    ${git} commit --verbose --all --no-edit --amend
  fi
''
