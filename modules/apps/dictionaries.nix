{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.apps.dictionaries.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.apps.dictionaries.enable {
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        hunspell
        ;
      inherit (pkgs.hunspellDicts)
        it_IT
        es_MX
        en_CA-large
        ;
    };
  };
}
