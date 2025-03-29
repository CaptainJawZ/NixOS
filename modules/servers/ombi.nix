{ lib, config, ... }:
let
  cfg = config.my.servers.ombi;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.ombi = setup.mkOptions "ombi" "requests" 3425;
  config = {
    services = {
      ombi = lib.mkIf cfg.enable {
        enable = true;
        inherit (cfg) port;
        openFirewall = !cfg.isLocal;
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverseFix cfg);
    };
  };
}
