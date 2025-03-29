{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.apps.office.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.apps.office.enable {
    environment.variables.CALIBRE_USE_SYSTEM_THEME = "1";
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        jre17_minimal # for libreoffice extensions
        libreoffice # office, but based
        calibre # ugly af eBook library manager
        newsflash # feed reader, syncs with nextcloud
        furtherance # I packaged this one tehee track time utility
        planify # let's pretend I will organize my tasks
        ;
    };
  };
}
