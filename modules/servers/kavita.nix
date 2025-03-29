{ lib, config, ... }:
let
  cfg = config.my.servers.kavita;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.kavita = setup.mkOptions "kavita" "library" config.services.kavita.settings.Port;
  config = {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    # sops.secrets.kavita-token = lib.mkIf cfg.enable {
    #   owner = config.users.users.kavita.name;
    #   inherit (config.users.users.kavita) group;
    # };
    users.users.kavita = lib.mkIf cfg.enable {
      isSystemUser = true;
      group = "kavita";
      extraGroups = [
        "users"
        "piracy"
      ];
    };
    services = {
      kavita = lib.mkIf cfg.enable {
        enable = true;
        # tokenKeyFile = config.sops.secrets.kavita-token.path;
        tokenKeyFile = ../../secrets/supersecret;
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverse cfg);
    };
  };
}
