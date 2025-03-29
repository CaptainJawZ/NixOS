{ lib, config, ... }:
let
  cfg = config.my.servers.shiori;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.shiori = setup.mkOptions "shiori" "bookmarks" 4368;
  config = lib.mkIf (config.my.servers.shiori.enable && config.my.servers.postgres.enable) {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    # sops.secrets = lib.mkIf cfg.enable { shiori.sopsFile = ../../secrets/env.yaml; };
    services = {
      shiori = lib.mkIf cfg.enable {
        inherit (cfg) port;
        enable = true;
        # environmentFile = config.sops.secrets.shiori.path;
        databaseUrl = "postgres:///shiori?host=${config.my.postgresSocket}";
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverse cfg);
    };
  };
}
