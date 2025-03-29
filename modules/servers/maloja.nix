{ lib, config, ... }:
let
  cfg = config.my.servers.maloja;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.maloja = setup.mkOptions "maloja" "maloja" 42010;
  config = {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    # sops.secrets = lib.mkIf cfg.enable { maloja.sopsFile = ../../secrets/env.yaml; };
    virtualisation.oci-containers.containers.maloja = lib.mkIf cfg.enable {
      image = "krateng/maloja:3.2.3";
      ports = [ "${toString cfg.port}:${toString cfg.port}" ];
      # environmentFiles = [ config.sops.secrets.maloja.path ];
      environment = {
        TZ = config.my.timeZone;
        MALOJA_TIMEZONE = "-6";
        PUID = toString config.users.users.jawz.uid;
        PGID = toString config.users.groups.users.gid;
        MALOJA_DATA_DIRECTORY = "/mljdata";
        MALOJA_SKIP_SETUP = "true";
      };
      volumes = [ "${config.my.containerData}/maloja:/mljdata" ];
    };
    services.nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverse cfg);
  };
}
