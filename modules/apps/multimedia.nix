{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.apps.multimedia.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.apps.multimedia.enable {
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        recordbox # libadwaita music player
        pitivi # video editor
        celluloid # video player
        curtail # image compressor
        easyeffects # equalizer
        handbrake # video converter, may be unnecessary
        identity # compare images or videos
        mousai # poor man shazam
        shortwave # listen to world radio
        tagger # tag music files
        ;
    };
  };
}
