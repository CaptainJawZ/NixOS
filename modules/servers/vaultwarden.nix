{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.my.servers.vaultwarden;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.vaultwarden = setup.mkOptions "vaultwarden" "vault" 8222;
  config = lib.mkIf (cfg.enable && config.my.servers.postgres.enable) {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    # sops.secrets = lib.mkIf cfg.enable { vaultwarden.sopsFile = ../../secrets/env.yaml; };
    services = {
      vaultwarden = lib.mkIf cfg.enable {
        enable = true;
        dbBackend = "postgresql";
        package = pkgs.vaultwarden;
        # environmentFile = config.sops.secrets.vaultwarden.path;
        config = {
          ROCKET_ADDRESS = "${config.my.localhost}";
          ROCKET_PORT = cfg.port;
          WEBSOCKET_PORT = 8333;
          DATABASE_URL = "postgresql:///${cfg.name}?host=${config.my.postgresSocket}";
          ENABLE_DB_WAL = false;
          WEBSOCKET_ENABLED = true;
          SHOW_PASSWORD_HINT = false;
          EXTENDED_LOGGING = true;
          LOG_LEVEL = "warn";
        };
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverse cfg);
    };
  };
}
