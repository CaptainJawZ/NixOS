{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.apps.misc.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.apps.misc.enable {
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        collector # stores things and throws them anywhere
        blanket # background noise
        metadata-cleaner # remove any metadata and geolocation from files
        pika-backup # backups
        gnome-obfuscate # censor private information
        ;
    };
  };
}
