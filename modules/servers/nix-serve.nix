{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.my.servers.nix-serve;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.nix-serve = setup.mkOptions "nix-serve" "cache" 5000;
  config = lib.mkIf cfg.enable {
    # sops.secrets."private_cache_keys/miniserver".sopsFile = ../../secrets/keys.yaml;
    services = {
      nix-serve = {
        enable = true;
        openFirewall = true;
        package = pkgs.nix-serve-ng;
        inherit (cfg) port;
        # secretKeyFile = config.sops.secrets."private_cache_keys/miniserver".path;
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverse cfg);
    };
  };
}
