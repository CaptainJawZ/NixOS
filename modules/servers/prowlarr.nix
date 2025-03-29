{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.servers.prowlarr;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.prowlarr = setup.mkOptions "prowlarr" "indexer" 9696;
  config = {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    users.users.prowlarr = lib.mkIf cfg.enable {
      group = "piracy";
      isSystemUser = true;
    };
    services = {
      prowlarr.enable = cfg.enable;
      flaresolverr = {
        inherit (cfg) enable;
        package = pkgs.nur.repos.xddxdd.flaresolverr-21hsmw;
        openFirewall = true;
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverseFix cfg);
    };
  };
}
