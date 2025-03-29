{ lib, config, ... }:
let
  cfg = config.my.servers.synapse;
  setup = import ./setup.nix { inherit lib config; };
  clientConfig."m.homeserver".base_url = cfg.url;
  serverConfig."m.server" = "${cfg.host}:443";
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in
{
  options.my.servers.synapse = setup.mkOptions "synapse" "chat" 8008;
  config = {
    # sops.secrets = lib.mkIf cfg.enable {
    #   synapse = {
    #     sopsFile = ../../secrets/env.yaml;
    #     owner = "matrix-synapse";
    #     group = "matrix-synapse";
    #   };
    # };
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    services = lib.mkIf cfg.enable {
      matrix-synapse = {
        enable = true;
        extraConfigFiles = [
          # config.sops.secrets.synapse.path
        ];
        settings = {
          server_name = cfg.domain;
          public_baseurl = cfg.url;
          federation_domain_whitelist = [ cfg.domain ];
          allow_public_rooms_without_auth = false;
          allow_public_rooms_over_federation = false;
          max_upload_size = "4096M";
          listeners = [
            {
              inherit (cfg) port;
              bind_addresses = [ "::1" ];
              type = "http";
              tls = false;
              x_forwarded = true;
              resources = [
                {
                  names = [
                    "client"
                    "media"
                  ];
                  compress = true;
                }
              ];
            }
          ];
        };
      };
      nginx.virtualHosts = lib.mkIf cfg.enableProxy {
        "${cfg.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
          locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
        };
        "${cfg.host}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/".extraConfig = ''
              return 404;
            '';
            "/_matrix".proxyPass = "http://[::1]:${toString cfg.port}";
            "/_synapse/client".proxyPass = "http://[::1]:${toString cfg.port}";
          };
        };
      };
    };
  };
}
