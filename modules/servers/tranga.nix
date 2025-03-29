{ config, lib, ... }:
let
  setup = import ./setup.nix { inherit lib config; };
  cfg = config.my.servers.tranga;
in
{
  options.my.servers.tranga = setup.mkOptions "tranga" "tranga" 9555;
  config = {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    virtualisation.oci-containers.containers = lib.mkIf cfg.enable {
      tranga-api = {
        image = "glax/tranga-api:latest";
        user = "${toString config.users.users.jawz.uid}:${toString config.users.groups.kavita.gid}";
        environment.TZ = config.my.timeZone;
        ports = [ "6531:6531" ];
        volumes = [
          "/srv/pool/multimedia/media/Library/Manga:/Manga"
          "${config.my.containerData}/tranga-api:/usr/share/tranga-api"
        ];
      };
      tranga-website = {
        image = "glax/tranga-website:latest";
        ports = [ "${toString cfg.port}:80" ];
        dependsOn = [ "tranga-api" ];
        environment.TZ = config.my.timeZone;
      };
    };
  };
}
