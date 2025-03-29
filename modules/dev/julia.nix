{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.my.dev.julia.enable = lib.mkEnableOption "enable";

  config = lib.mkIf config.my.dev.julia.enable {
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs) julia;
    };
  };
}
