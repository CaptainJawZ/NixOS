{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.my.servers.jellyfin;
  inherit (inputs.jawz-scripts.packages.x86_64-linux) sub-sync;
  sub-sync-path = [
    pkgs.nix
    pkgs.bash
    pkgs.fd
    pkgs.ripgrep
    pkgs.file
    pkgs.alass
    pkgs.ffmpeg
    pkgs.gum
    sub-sync
  ];
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers.jellyfin = setup.mkOptions "jellyfin" "flix" 8096;
  config = {
    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.isLocal) [ cfg.port ];
    environment = {
      systemPackages = lib.mkIf cfg.enable (
        [ pkgs.jellyfin-ffmpeg ] ++ (if cfg.enableCron then sub-sync-path else [ ])
      );
    };
    services = {
      jellyfin = lib.mkIf cfg.enable {
        enable = true;
        group = "piracy";
      };
      nginx = lib.mkIf cfg.enableProxy {
        appendHttpConfig = ''
          # JELLYFIN
          proxy_cache_path /var/cache/nginx/jellyfin levels=1:2 keys_zone=jellyfin:100m max_size=15g inactive=1d use_temp_path=off;
          map $request_uri $h264Level { ~(h264-level=)(.+?)& $2; }
          map $request_uri $h264Profile { ~(h264-profile=)(.+?)& $2; }
        '';
        virtualHosts."${cfg.host}" = {
          forceSSL = true;
          enableACME = true;
          http2 = true;
          extraConfig = ''
            # use a variable to store the upstream proxy
            # in this example we are using a hostname which is resolved via DNS
            # (if you aren't using DNS remove the resolver line and change the variable to point to an IP address
            resolver ${cfg.ip} valid=30;

            location = / {
              return 302 http://$host/web/;
              #return 302 https://$host/web/;
            }

            location = /web/ {
              # Proxy main Jellyfin traffic
              proxy_pass ${cfg.local}/web/index.html;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Protocol $scheme;
              proxy_set_header X-Forwarded-Host $http_host;
            }
          '';
          locations = {
            "/" = {
              proxyPass = cfg.local;
              proxyWebsockets = true;
            };
            "/socket" = {
              proxyPass = cfg.local;
              extraConfig = ''
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
              '';
            };
            "~ /Items/(.*)/Images" = {
              proxyPass = cfg.local;
              extraConfig = ''
                proxy_cache jellyfin;
                proxy_cache_revalidate on;
                proxy_cache_lock on;
              '';
            };
          };
        };
      };
    };
    systemd = lib.mkIf cfg.enableCron {
      services.sub-sync = {
        restartIfChanged = true;
        description = "syncronizes subtitles downloaded & modified today";
        wantedBy = [ "default.target" ];
        path = sub-sync-path;
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = 30;
          ExecStart = "${sub-sync}/bin/sub-sync all";
          Type = "simple";
          User = "root";
        };
      };
      timers.sub-sync = {
        enable = true;
        description = "syncronizes subtitles downloaded & modified today";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "20:00";
        };
      };
    };
  };
}
