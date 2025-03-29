{ lib, config, ... }:
let
  cfg = config.my.servers.radarr;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.radarr = setup.mkOptions "radarr" "movies" 7878;
  config = {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    services = {
      radarr = lib.mkIf cfg.enable {
        enable = true;
        group = "piracy";
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverseFix cfg);
    };
  };
}
