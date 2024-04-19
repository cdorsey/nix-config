{ pkgs, ... }:
let
  git = "${pkgs.git}/bin/git";
  nixfmt = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
  nh = "${pkgs.nh}/bin/nh";
in
pkgs.writeShellScriptBin "nixos-switch" ''
  set -ex

  SYSTEM_FILES=('flake.*' 'system/*.nix')
  USER_FILES=('user/*.nix')

  pushd ~/.dotfiles > /dev/null

  MODIFIED_NIX=$(${git} ls-files -m | grep '\.nix$')
  if [[ -n $MODIFIED_NIX ]]; then
    ${nixfmt} $MODIFIED_NIX
  fi

  # Update the system config if needed
  if ! ${git} diff --quiet --ignore-all-space -- $SYSTEM_FILES; then
    ${nh} os switch
    ${git} add flake.* system/**/*.nix
    ${git} commit -m "$(nixos-rebuild list-generations 2>/dev/null | grep current)"
  fi

  # Update the user config if needed
  if ! ${git} diff --quiet --ignore-all-space -- $USER_FILES; then
    ${nh} home switch
    ${git} add user/**/*.nix
    ${git} commit -m "$(home-manager generations | head -n1)"
  fi

  # If there are remaining changed files, amend them to the last commit
  if ! ${git} diff --quiet --ignore-all-space; then
    ${git} commit --verbose --all --no-edit --amend
  fi

  popd > /dev/null || true
''
# ----
