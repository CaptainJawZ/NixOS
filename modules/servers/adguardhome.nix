{ lib, config, ... }:
{
  options.my.servers.adguardhome.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.servers.adguardhome.enable {
    services.adguardhome = {
      enable = true;
      mutableSettings = true;
      openFirewall = true;
    };
  };
}
