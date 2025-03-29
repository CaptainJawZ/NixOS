{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.apps.internet.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.apps.internet.enable {
    programs = {
      geary.enable = true;
      firefox = {
        enable = true;
        package = pkgs.librewolf; # fuck u firefox
        languagePacks = [
          "en-CA"
          "es-MX"
          "it"
        ];
      };
    };
    users.users.jawz.packages = builtins.attrValues {
      inherit (inputs.jawz-scripts.packages.x86_64-linux)
        vdhcoapp # video download helper assistant
        talk # nextcloud talk client
        ;
      inherit (pkgs)
        thunderbird # email client
        warp # transfer files with based ppl
        brave # crypto-browser that at least somewhat integrates with gtk
        nextcloud-client # self-hosted google-drive alternative
        fragments # beautiful torrent client
        tor-browser-bundle-bin # dark web, so dark!
        telegram-desktop # furry chat
        nicotine-plus # remember Ares?
        discord # :3
        ;
    };
  };
}
