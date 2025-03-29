{ lib, config, ... }:
let
  cfg = config.my.servers.audiobookshelf;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.audiobookshelf = setup.mkOptions "audiobookshelf" "audiobooks" 5687;
  config = {
    my.servers.audiobookshelf.enableSocket = true;
    services = {
      audiobookshelf = lib.mkIf cfg.enable {
        inherit (cfg) port;
        enable = true;
        host = cfg.ip;
        group = "piracy";
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverseFix cfg);
    };
  };
}
