{ lib, config, ... }:
let
  cfg = config.my.servers.drpp;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.drpp = setup.mkOptions "drpp" "drpp" 0;
  config = {
    virtualisation.oci-containers.containers.drpp = lib.mkIf cfg.enable {
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
