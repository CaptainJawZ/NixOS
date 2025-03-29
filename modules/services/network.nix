{ config, lib, ... }:
{
  options.my.services.network.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.services.network.enable {
    networking = {
      enableIPv6 = true;
      firewall.enable = true;
      dhcpcd.extraConfig = "nohook resolv.conf";
      networkmanager = {
        enable = true;
        dns = "none";
      };
      hosts = config.my.ips |> lib.mapAttrs' (hostname: ip: lib.nameValuePair ip [ hostname ]);
      interfaces."${config.my.interfaces.${config.networking.hostName}}".wakeOnLan.enable = true;
    };
    services.dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
        server_names = [
          "adfilter-adl"
          "adfilter-adl-ipv6"
          "adfilter-per"
          "adfilter-per-ipv6"
          "adfilter-syd"
          "adfilter-syd-ipv6"
          "mullvad-adblock-doh"
          "mullvad-doh"
          "nextdns"
          "nextdns-ipv6"
          "quad9-dnscrypt-ip4-filter-pri"
          "quad9-dnscrypt-ip6-filter-pri"
          "ibksturm"
        ];
      };
    };
    systemd.services.dnscrypt-proxy2.serviceConfig = {
      StateDirectory = "dnscrypt-proxy";
    };
  };
}
