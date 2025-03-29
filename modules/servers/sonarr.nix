{ lib, config, ... }:
let
  cfg = config.my.servers.sonarr;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.sonarr = setup.mkOptions "sonarr" "series" 8989;
  config = {
    services = {
      sonarr = lib.mkIf cfg.enable {
        enable = true;
        group = "piracy";
        openFirewall = !cfg.isLocal;
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverseFix cfg);
    };
  };
}
