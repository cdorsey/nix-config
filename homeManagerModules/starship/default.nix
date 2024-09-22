{ config, lib, ... }:
{
  imports = [
    ./presets/bracketed.nix
    ./presets/nerd-font-symbols.nix
  ];

  programs.starship = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    enableBashIntegration = config.programs.bash.enable;

    settings = {
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
    };
  };
}
