{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.dev.python.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.dev.python.enable {
    home-manager.users.jawz.xdg.configFile."python/pythonrc".source = ../../dotfiles/pythonrc;
    environment.variables.PYTHONSTARTUP = "\${XDG_CONFIG_HOME}/python/pythonrc";
    users.users.jawz.packages =
      builtins.attrValues {
        inherit (pkgs)
          pipenv # python development workflow for humans
          pyright # LSP
          ;
      }
      ++ [
        (pkgs.python3.withPackages (
          ps:
          builtins.attrValues {
            inherit (ps)
              black # Python code formatter
              editorconfig # follow rules of contributin
              flake8 # wraper for pyflakes, pycodestyle and mccabe
              isort # sort Python imports
              pyflakes # checks source code for errors
              pylint # bug and style checker for python
              pytest # tests
              speedtest-cli # check internet speed from the comand line
              ;
          }
        ))
      ];
  };
}
