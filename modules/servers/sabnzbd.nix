{ lib, config, ... }:
{
  options.my.servers.sabnzbd = {
    enable = lib.mkEnableOption "enable";
    port = lib.mkOption {
      type = lib.types.int;
      default = 3399;
      description = "The port to access sabnzbd web-ui";
    };
  };
  config = lib.mkIf config.my.servers.sabnzbd.enable {
    networking.firewall.allowedTCPPorts = [ config.my.servers.sabnzbd.port ];
    services.sabnzbd = {
      enable = true;
      group = "piracy";
      openFirewall = true;
    };
  };
}
