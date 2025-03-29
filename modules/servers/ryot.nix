{ lib, config, ... }:
let
  cfg = config.my.servers.ryot;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.ryot = setup.mkOptions "ryot" "tracker" 8765;
  config = lib.mkIf (config.my.servers.ryot.enable && config.my.servers.postgres.enable) {
    # sops.secrets.ryot.sopsFile = ../../secrets/env.yaml;
    virtualisation.oci-containers.containers.ryot = {
      image = "ghcr.io/ignisda/ryot:v8";
      ports = [ "${toString cfg.port}:8000" ];
      # environmentFiles = [ config.sops.secrets.ryot.path ];
      environment = {
        RUST_LOG = "ryot=debug,sea_orm=debug";
        TZ = "America/Mexico_City";
        DATABASE_URL = "postgres:///ryot?host=${config.my.postgresSocket}";
        FRONTEND_INSECURE_COOKIES = "true";
      };
      volumes = [ "${config.my.postgresSocket}:${config.my.postgresSocket}" ];
    };
    services.nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverse cfg);
  };
}
