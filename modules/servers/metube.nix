{ lib, config, ... }:
let
  cfg = config.my.servers.metube;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.metube = setup.mkOptions "metube" "bajameesta" 8881;
  config = {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    virtualisation.oci-containers.containers.metube = lib.mkIf cfg.enable {
      image = "ghcr.io/alexta69/metube:2024-11-05";
      ports = [ "${toString cfg.port}:8081" ];
      volumes = [
        "${config.my.containerData}/metube:/downloads"
        "/home/jawz/.local/share/cookies.txt:/cookies.txt"
      ];
      environment = {
        TZ = config.my.timeZone;
        YTDL_OPTIONS = ''{"cookiefile":"/cookies.txt"}'';
        PUID = toString config.users.users.jawz.uid;
        PGID = toString config.users.groups.piracy.gid;
      };
    };
    services.nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverse cfg);
  };
}
