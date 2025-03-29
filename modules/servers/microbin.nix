{ lib, config, ... }:
let
  cfg = config.my.servers.microbin;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.microbin = setup.mkOptions "microbin" "copy" 8080;
  config = lib.mkIf config.my.servers.microbin.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    services = {
      microbin = lib.mkIf cfg.enable {
        enable = true;
        settings = {
          MICROBIN_PORT = cfg.port;
          MICROBIN_HIDE_LOGO = false;
          MICROBIN_HIGHLIGHTSYNTAX = true;
          MICROBIN_PRIVATE = true;
          MICROBIN_QR = true;
          MICROBIN_ENCRYPTION_CLIENT_SIDE = true;
          MICROBIN_ENCRYPTION_SERVER_SIDE = true;
        };
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverse cfg);
    };
  };
}
