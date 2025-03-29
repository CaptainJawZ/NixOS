{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.apps.piano.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.apps.piano.enable {
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        neothesia
        linthesia
        timidity
        ;
    };
  };
}
