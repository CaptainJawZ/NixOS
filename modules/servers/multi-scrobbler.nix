{ lib, config, ... }:
let
  cfg = config.my.servers.multi-scrobbler;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.multi-scrobbler = setup.mkOptions "multi-scrobbler" "scrobble" 9078;
  config = {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    # sops.secrets = lib.mkIf cfg.enable { multi-scrobbler.sopsFile = ../../secrets/env.yaml; };
    virtualisation.oci-containers.containers.multi-scrobbler = lib.mkIf cfg.enable {
      image = "foxxmd/multi-scrobbler:0.9.1";
      ports = [ "${toString cfg.port}:${toString cfg.port}" ];
      # environmentFiles = [ config.sops.secrets.multi-scrobbler.path ];
      environment = {
        TZ = config.my.timeZone;
        PUID = toString config.users.users.jawz.uid;
        PGID = toString config.users.groups.users.gid;
        BASE_URL = cfg.url;
        DEEZER_REDIRECT_URI = "http://${config.my.ips.${cfg.hostName}}:${toString cfg.port}/deezer/callback";
        MALOJA_URL = "http://192.168.1.100:42010";
        JELLYFIN_URL = "http://192.168.1.69:8096";
        PLEX_URL = "http://192.168.1.69:32400";
        WS_ENABLE = "true";
      };
      volumes = [ "${config.my.containerData}/multi-scrobbler:/config" ];
    };
    services.nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverse cfg);
  };
}
