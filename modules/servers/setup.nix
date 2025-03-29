{ lib, config, ... }:
let
  mkOptions = name: subdomain: port: {
    enable = lib.mkEnableOption "enable";
    enableCron = lib.mkEnableOption "enable cronjob";
    enableProxy = lib.mkEnableOption "enable reverse proxy";
    port = lib.mkOption {
      type = lib.types.int;
      default = port;
    };
    name = lib.mkOption {
      type = lib.types.str;
      default = name;
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = config.my.domain;
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = "${subdomain}.${config.my.servers.${name}.domain}";
    };
    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "https://${config.my.servers.${name}.host}";
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default =
        if config.my.servers."${name}".isLocal then
          config.my.localhost
        else
          config.my.ips."${config.my.servers.${name}.hostName}";
    };
    local = lib.mkOption {
      type = lib.types.str;
      default = "http://${config.my.servers.${name}.ip}:${toString port}";
    };
    isLocal = lib.mkOption {
      type = lib.types.bool;
      default = "${config.my.servers.${name}.hostName}" == config.my.mainServer;
    };
    enableSocket = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  proxy = locations: {
    inherit locations;
    forceSSL = true;
    enableACME = true;
    http2 = true;
  };
  proxyReverse =
    cfg:
    proxy {
      "/" = {
        proxyPass = "http://${cfg.ip}:${toString cfg.port}/";
        proxyWebsockets = cfg.enableSocket;
      };
    };
  proxyReverseFix =
    cfg:
    let
      useLocalhost = cfg.hostName == config.networking.hostName;
      localHeaders = ''
        proxy_set_header   Host $host;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
      '';
    in
    proxyReverse cfg
    // {
      extraConfig = ''
        ${if useLocalhost then localHeaders else ""}
        proxy_set_header   X-Forwarded-Host $host;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection $http_connection;
        proxy_redirect     off;
        proxy_http_version 1.1;
      '';
    };
in
{
  inherit
    mkOptions
    proxy
    proxyReverse
    proxyReverseFix
    ;
}
