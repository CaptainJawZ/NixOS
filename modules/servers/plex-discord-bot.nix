{ lib, config, ... }:
let
  cfg = config.my.servers.plex-discord-bot;
  setup = import ./setup.nix { inherit lib config; };
  name = "plex-discord-bot";
in
{
  options.my.servers.plex-discord-bot = setup.mkOptions name name 0;
  config = {
    virtualisation.oci-containers.containers.plex-discord-bot = lib.mkIf cfg.enable {
      image = "ghcr.io/phin05/discord-rich-presence-plex:latest";
      environment = {
        DRPP_UID = toString config.users.users.jawz.uid;
        DRPP_GID = toString config.users.groups.users.gid;
      };
      volumes = [
        "${config.my.containerData}/drpp:/app/data"
        "/run/user/${toString config.users.users.jawz.uid}:/run/app"
      ];
    };
  };
}
