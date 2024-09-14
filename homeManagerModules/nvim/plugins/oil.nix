{ ... }:
{
  programs.nixvim.plugins.oil = {
    enable = true;

    settings = {
      default_file_explorer = true;
      use_default_keymaps = true;
      view_options = {
        is_hidden_file.__raw = ''
          function(name, _)
          for _, hidden in ipairs({'.git', '.jj', 'node_modules', '.venv', '.direnv'}) do
            if hidden == name then
              return true
            end
          end

          return false
          end
        '';

      };
      keymaps = {
        "q" = "actions.close";
      };
    };
  };

}
