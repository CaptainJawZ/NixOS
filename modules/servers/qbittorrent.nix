{
  lib,
  config,
  pkgs,
  ...
}:
let
  qbit_manage_env = pkgs.python3.withPackages (
    ps:
    builtins.attrValues {
      inherit (ps)
        croniter
        gitpython
        humanize
        pytimeparse2
        qbittorrent-api
        requests
        retrying
        ruamel-yaml
        schedule
        bencode-py
        ;
    }
  );
in
{
  options.my.servers = {
    unpackerr.enable = lib.mkEnableOption "enable";
    qbittorrent = {
      enable = lib.mkEnableOption "enable";
      port = lib.mkOption {
        type = lib.types.int;
        default = 9091;
        description = "The port to access qbittorrent web-ui";
      };
    };
  };
  config = lib.mkIf config.my.servers.qbittorrent.enable {
    home-manager.users.jawz.xdg.configFile."unpackerr.conf" =
      lib.mkIf config.my.servers.unpackerr.enable
        { source = ../../dotfiles/unpackerr.conf; };
    systemd = {
      packages = [ pkgs.qbittorrent-nox ];
      services = {
        "qbittorrent-nox@jawz" = {
          enable = true;
          overrideStrategy = "asDropin";
          wantedBy = [ "multi-user.target" ];
        };
      };
      user = {
        services = {
          qbit_manage = {
            restartIfChanged = true;
            description = "Tidy up my torrents";
            wantedBy = [ "default.target" ];
            serviceConfig =
              let
                env = "/home/jawz/Development/Git/qbit_manage";
              in
              {
                Restart = "on-failure";
                RestartSec = 30;
                ExecStart = "${qbit_manage_env}/bin/python ${env}/qbit_manage.py -r -c ${env}/config.yml";
              };
          };
          unpackerr = lib.mkIf config.my.servers.unpackerr.enable {
            enable = true;
            restartIfChanged = true;
            description = "Run unpackerr";
            wantedBy = [ "default.target" ];
            serviceConfig = {
              Restart = "on-failure";
              RestartSec = 30;
              ExecStart = "${pkgs.unpackerr}/bin/unpackerr -c /home/jawz/.config/unpackerr.conf";
            };
          };
        };
        timers.qbit_manage = {
          enable = true;
          description = "Tidy up my torrents";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "*:0/10";
          };
        };
      };
    };
    networking.firewall =
      let
        ports = [
          51411
          51412
          51413
        ];
      in
      {
        allowedTCPPorts = ports ++ [ config.my.servers.qbittorrent.port ];
        allowedUDPPorts = ports;
      };
  };
}
