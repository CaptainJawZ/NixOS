{ lib, config, ... }:
let
  enableContainers = lib.any (opt: opt) [
    config.my.servers.collabora.enable
    config.my.servers.ryot.enable
    config.my.servers.lidarr.enable
    config.my.servers.prowlarr.enable
    config.my.servers.maloja.enable
    config.my.servers.multi-scrobbler.enable
    config.my.servers.metube.enable
    config.my.servers.go-vod.enable
    config.my.servers.tranga.enable
  ];
  filterNames = file: file != "base.nix" && file != "setup.nix";
  autoImport =
    dir:
    builtins.readDir ./${dir}
    |> builtins.attrNames
    |> builtins.filter (file: builtins.match ".*\\.nix" file != null && filterNames file)
    |> map (file: ./${dir}/${file});
in
{
  imports =
    autoImport "apps"
    ++ autoImport "dev"
    ++ autoImport "scripts"
    ++ autoImport "servers"
    ++ autoImport "services"
    ++ autoImport "shell";
  options.my = {
    localhost = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "The localhost address.";
    };
    localhost6 = lib.mkOption {
      type = lib.types.str;
      default = "::1";
      description = "The localhost ipv6 address.";
    };
    routerip = lib.mkOption {
      type = lib.types.str;
      default = "192.168.1.254";
      description = "The ip address of my router.";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = "servidos.lat";
      description = "The domain name.";
    };
    ips = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        server = "192.168.1.69";
        miniserver = "192.168.1.100";
        workstation = "192.168.1.64";
      };
      description = "Set of IP's for all my computers.";
    };
    interfaces = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        server = "enp0s31f6";
        miniserver = "enp2s0";
        workstation = "enp5s0";
      };
      description = "Set of network interface names for all my computers.";
    };
    mainServer = lib.mkOption {
      type = lib.types.str;
      default = "miniserver";
      description = "The hostname of the main server.";
    };
    postgresSocket = lib.mkOption {
      type = lib.types.str;
      default = "/run/postgresql";
      description = "The PostgreSQL socket path.";
    };
    containerSocket = lib.mkOption {
      type = lib.types.str;
      default = "/var/run/docker.sock";
      description = "The docker/podman socket path.";
    };
    containerData = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/docker-configs";
      description = "The docker/podman socket path.";
    };
    smtpemail = lib.mkOption {
      type = lib.types.str;
      default = "stunner6399@gmail.com";
      description = "localhost smtp email";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "CaptainJawZ@protonmail.com";
      description = "localhost smtp email";
    };
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "America/Mexico_City";
      description = "Timezone";
    };
    enableContainers = lib.mkEnableOption "enable";
    enableProxy = lib.mkEnableOption "enable";
  };
  config = {
    virtualisation = {
      containers.enable = true;
      oci-containers.backend = "podman";
      podman = lib.mkIf (enableContainers || config.my.enableContainers) {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
        autoPrune = {
          enable = true;
          flags = [ "--all" ];
          dates = "weekly";
        };
      };
    };
    security.acme = lib.mkIf config.services.nginx.enable {
      acceptTerms = true;
      defaults.email = config.my.email;
    };
    services.nginx = {
      enable = config.my.enableProxy;
      clientMaxBodySize = "4096m";
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
    };
    networking.firewall =
      let
        ports = [
          config.services.nginx.defaultHTTPListenPort
          config.services.nginx.defaultSSLListenPort
        ];
      in
      {
        allowedTCPPorts = ports;
        allowedUDPPorts = ports;
      };
  };
}
