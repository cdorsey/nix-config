{ config, lib, ... }:
let
  inherit (lib) mkMerge mkOption types;
  cfg = config.userConfig.starship;
in
{
  imports = [
    ./presets/bracketed.nix
    ./presets/nerd-font-symbols.nix
  ];

  options.userConfig.starship = {
    useBracketed = mkOption {
      type = types.bool;
      default = true;
    };
    useNerdFont = mkOption {
      type = types.bool;
      default = true;
    };

    disableModules = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config.programs.starship = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    enableBashIntegration = config.programs.bash.enable;

    settings = mkMerge (
      [
        {
          git_branch = {
            only_attached = true;
          };
          nodejs = {
            detect_files = [
              "package.json"
              ".node-version"
              "!bunfig.toml"
              "!bun.lockb"
            ];
          };
          cmd_duration.disabled = true;
          time = {
            disabled = false;
          };
          directory = {
            truncate_to_repo = false;
            truncation_symbol = ".../";
          };
        }
      ]
      ++ map (module: {
        ${module} = {
          disabled = true;
        };
      }) cfg.disableModules
    );
  };
}
