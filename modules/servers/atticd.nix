{ lib, config, ... }:
let
  cfg = config.my.servers.atticd;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.atticd = setup.mkOptions "atticd" "cache" 2343;
  config = lib.mkIf cfg.enable {
    # sops.secrets."private_cache_keys/atticd".sopsFile = ../../secrets/keys.yaml;
    services = {
      atticd = {
        enable = true;
        # environmentFile = config.sops.secrets."private_cache_keys/atticd".path;
        settings = {
          listen = "[::]:${toString cfg.port}";
          jwt = { };
          chunking = {
            nar-size-threshold = 64 * 1024; # 64 KiB
            min-size = 16 * 1024; # 16 KiB
            avg-size = 64 * 1024; # 64 KiB
            max-size = 256 * 1024; # 256 KiB
          };
          compression = {
            type = "xz";
            level = 16;
          };
          garbage-collection = {
            interval = "7 days";
            default-retention-period = "7 days";
          };
        };
      };
    };
  };
}
