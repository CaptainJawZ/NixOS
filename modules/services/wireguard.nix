{
  config,
  lib,
  pkgs,
  ...
}:
let
  port = 51820;
  interface = config.my.interfaces.${config.networking.hostName};
in
{
  options.my.services.wireguard.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.services.wireguard.enable {
    # sops.secrets."wireguard/private".sopsFile = ../../secrets/wireguard.yaml;
    networking = {
      firewall.allowedUDPPorts = [ port ];
      nat = {
        enable = true;
        externalInterface = interface;
        internalInterfaces = [ "wg0" ];
      };
      wireguard.interfaces.wg0 = {
        ips = [ "10.100.0.1/24" ];
        listenPort = port;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${interface} -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${interface} -j MASQUERADE
        '';
        # privateKeyFile = config.sops.secrets."wireguard/private".path;
        privateKey = "supersecret";
        peers = [
          {
            publicKey = "giPVRUTLtqPGb57R4foGZMNS0tjIp2ry6lMKYtqHjn4=";
            allowedIPs = [ "10.100.0.15/32" ];
          } # jeancarlos
        ];
      };
    };
  };
}
