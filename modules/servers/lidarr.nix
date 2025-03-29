{ lib, config, ... }:
let
  cfg = config.my.servers.lidarr;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.lidarr = setup.mkOptions "lidarr" "music" 8686;
  config = {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    virtualisation.oci-containers.containers.lidarr = lib.mkIf cfg.enable {
      autoStart = true;
      image = "linuxserver/lidarr:version-2.9.6.4552";
      ports = [ "${toString cfg.port}:${toString cfg.port}" ];
      environment = {
        TZ = config.my.timeZone;
        PUID = toString config.users.users.jawz.uid;
        PGID = toString config.users.groups.piracy.gid;
      };
      volumes = [
        "/srv/pool/multimedia:/data"
        "/srv/pool/multimedia/media/Music:/music"
        "/srv/pool/multimedia/media/MusicVideos:/music-videos"
        "/srv/pool/multimedia/downloads/usenet:/usenet"
        "/srv/pool/multimedia/downloads/torrent:/torrent"
        "${config.my.containerData}/lidarr/files:/config"
        "${config.my.containerData}/lidarr/custom-services.d:/custom-services.d"
        "${config.my.containerData}/lidarr/custom-cont-init.d:/custom-cont-init.d"
      ];
      extraOptions = [
        "--network=host"
      ];
    };
    services.nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverseFix cfg);
  };
}
