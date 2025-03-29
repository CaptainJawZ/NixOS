{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.shell.exercism.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.shell.exercism.enable {
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        exercism # learn to code
        bats # testing system, required by Exercism
        ;
    };
  };
}
