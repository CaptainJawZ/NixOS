{ lib, config, ... }:
let
  cfg = config.my.servers.mealie;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.mealie = setup.mkOptions "mealie" "mealie" 9925;
  config = {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    # sops.secrets = lib.mkIf cfg.enable { mealie.sopsFile = ../../secrets/env.yaml; };
    services = {
      mealie = lib.mkIf cfg.enable {
        enable = true;
        inherit (cfg) port;
        settings = {
          TZ = config.my.timeZone;
          DEFAULT_GROUP = "Home";
          BASE_URL = cfg.url;
          API_DOCS = "false";
          ALLOW_SIGNUP = "false";
          DB_ENGINE = "postgres";
          POSTGRES_URL_OVERRIDE = "postgresql://${cfg.name}:@/${cfg.name}?host=${config.my.postgresSocket}";
          MAX_WORKERS = "1";
          WEB_CONCURRENCY = "1";
          SMTP_HOST = "smtp.gmail.com";
          SMTP_PORT = "587";
        };
        # credentialsFile = config.sops.secrets.mealie.path;
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverse cfg);
    };
  };
}
