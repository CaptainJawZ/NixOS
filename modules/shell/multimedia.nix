{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.shell.multimedia.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.shell.multimedia.enable {
    home-manager.users.jawz.programs.gallery-dl = {
      enable = true;
      settings = import ../../dotfiles/gallery-dl.nix;
    };
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        yt-dlp # downloads videos from most video websites
        ffmpeg # not ffmpreg, the coolest video conversion tool!
        imagemagick # photoshop what??
        ffpb # make ffmpeg encoding... a bit fun
        ;
    };
  };
}
