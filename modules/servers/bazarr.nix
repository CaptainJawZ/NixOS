{ lib, config, ... }:
let
  cfg = config.my.servers.bazarr;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.bazarr = setup.mkOptions "bazarr" "subs" config.services.bazarr.listenPort;
  config = {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    services = {
      bazarr = lib.mkIf cfg.enable {
        enable = true;
        group = "piracy";
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverse cfg);
    };
  };
}
