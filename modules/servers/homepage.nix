{ lib, config, ... }:
let
  cfg = config.my.servers.homepage;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.homepage = setup.mkOptions "homepage" "home" 8082;
  config = {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    # sops.secrets = lib.mkIf cfg.enable { homepage.sopsFile = ../../secrets/homepage.yaml; };
    services = {
      homepage-dashboard = lib.mkIf cfg.enable {
        enable = true;
        listenPort = cfg.port;
        # environmentFile = config.sops.secrets.homepage.path;
        settings.layout = import ./homepage/layout.nix;
        widgets = import ./homepage/widgets.nix;
        services = import ./homepage/services.nix { inherit lib config; };
        bookmarks =
          builtins.readDir ./homepage/bookmarks
          |> builtins.attrNames
          |> builtins.filter (file: builtins.match ".*\\.nix" file != null)
          |> map (file: import ./homepage/bookmarks/${file});
      };
      nginx.virtualHosts."${cfg.host}" = lib.mkIf cfg.enableProxy (setup.proxyReverse cfg);
    };
  };
}
