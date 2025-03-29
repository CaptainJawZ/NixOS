{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  commonProxyConfig = ''
    proxy_set_header Host $host;
  '';
  commonWebsocketConfig = ''
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_set_header Host $host;
    proxy_read_timeout 36000s;
  '';
  exiftool = pkgs.perlPackages.buildPerlPackage (
    let
      version = "12.70";
    in
    {
      pname = "Image-ExifTool";
      inherit version;
      src = pkgs.fetchurl {
        url = "https://exiftool.org/Image-ExifTool-${version}.tar.gz";
        hash = "sha256-TLJSJEXMPj870TkExq6uraX8Wl4kmNerrSlX3LQsr/4=";
      };
    }
  );
  cfg = config.my.servers.nextcloud;
  cfgC = config.my.servers.collabora;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.servers = {
    nextcloud = setup.mkOptions "nextcloud" "cloud" 80;
    collabora = setup.mkOptions "collabora" "collabora" 9980;
    go-vod.enable = lib.mkEnableOption "enable";
  };
  config = lib.mkIf (cfg.enable && config.my.servers.postgres.enable) {
    # sops.secrets = {
    #   smtp-password = { };
    #   nextcloud-adminpass = {
    #     owner = config.users.users.nextcloud.name;
    #     inherit (config.users.users.nextcloud) group;
    #   };
    # };
    nixpkgs.config.permittedInsecurePackages = [
      "nodejs-14.21.3"
      "openssl-1.1.1v"
    ];
    users.users.nextcloud = {
      isSystemUser = true;
      extraGroups = [ "render" ];
      packages =
        builtins.attrValues {
          inherit (pkgs)
            ffmpeg
            mediainfo
            nodejs
            perl
            ;
        }
        ++ [
          exiftool
          (pkgs.python311.withPackages (ps: [ ps.tensorflow ]))
        ];

    };
    programs.msmtp = {
      enable = true;
      accounts.default = {
        auth = true;
        host = "smtp.gmail.com";
        port = 587;
        tls = true;
        from = config.my.smtpemail;
        user = config.my.smtpemail;
        # passwordeval = "cat ${config.sops.secrets.smtp-password.path}";
      };
    };
    services = {
      nextcloud = {
        enable = true;
        https = true;
        package = pkgs.nextcloud31;
        appstoreEnable = true;
        configureRedis = true;
        extraAppsEnable = true;
        enableImagemagick = true;
        maxUploadSize = "4096M";
        hostName = cfg.host;
        caching = {
          redis = true;
          memcached = true;
          apcu = true;
        };
        extraApps = {
          inherit (config.services.nextcloud.package.packages.apps)
            bookmarks
            calendar
            contacts
            # files_texteditor
            # files_markdown
            forms
            integration_openai
            mail
            notes
            # maps
            music
            memories
            news
            previewgenerator
            richdocuments
            tasks
            # twofactor_top
            ;
          facerecognition = pkgs.fetchNextcloudApp {
            url = "https://github.com/matiasdelellis/facerecognition/releases/download/v0.9.60/facerecognition.tar.gz";
            hash = "sha256-FtYItN0Iy2QpSNf0GPs7fIPYgBdEuKHJGwZ7GQNySZE=";
            license = "agpl3Only";
          };
        };
        config = {
          # adminpassFile = config.sops.secrets.nextcloud-adminpass.path;
          adminpassFile = "${../../secrets/supersecret}";
          dbtype = "pgsql";
          dbhost = config.my.postgresSocket;
          dbname = "nextcloud";
        };
        phpOptions = {
          catch_workers_output = "yes";
          display_errors = "stderr";
          error_reporting = "E_ALL & ~E_DEPRECATED & ~E_STRICT";
          expose_php = "Off";
          preview_max_x = 2048;
          preview_max_y = 2048;
          short_open_tag = "Off";
          "opcache.enable_cli" = "1";
          "opcache.fast_shutdown" = "1";
          "opcache.interned_strings_buffer" = "16";
          "opcache.jit" = "1255";
          "opcache.jit_buffer_size" = "256M";
          "opcache.max_accelerated_files" = "10000";
          "opcache.huge_code_pages" = "1";
          "opcache.enable_file_override" = "1";
          "opcache.memory_consumption" = "256";
          "opcache.revalidate_freq" = "60";
          "opcache.save_comments" = "1";
          "opcache.validate_timestamps" = "0";
          "openssl.cafile" = "/etc/ssl/certs/ca-certificates.crt";
        };
        settings = {
          log_type = "file";
          loglevel = 1;
          trusted_proxies = [
            config.my.localhost
            config.my.localhost6
            config.my.routerip
          ];
          trusted_domains = [
            config.my.ips.${config.networking.hostName}
            "localhost"
            "cloud.servidos.lat"
          ];
          overwriteprotocol = "https";
          "overwrite.cli.url" = "${cfg.url}";
          forwarded_for_headers = [ "HTTP_X_FORWARDED_FOR" ];
          default_phone_region = "MX";
          allow_local_remote_servers = true;
          mail_smtpmode = "sendmail";
          mail_sendmailmode = "pipe";
          preview_ffmpeg_path = "${pkgs.ffmpeg}/bin/ffmpeg";
          "memories.exiftool" = "${exiftool}/bin/exiftool";
          "memories.ffmpeg_path" = "${pkgs.ffmpeg}/bin/ffmpeg";
          "memories.ffprobe_path" = "${pkgs.ffmpeg}/bin/ffprobe";
          enabledPreviewProviders = [
            "OC\\Preview\\AVI"
            "OC\\Preview\\BMP"
            "OC\\Preview\\GIF"
            "OC\\Preview\\HEIC"
            "OC\\Preview\\Image"
            "OC\\Preview\\JPEG"
            "OC\\Preview\\Krita"
            "OC\\Preview\\MKV"
            "OC\\Preview\\MP3"
            "OC\\Preview\\MP4"
            "OC\\Preview\\MarkDown"
            "OC\\Preview\\Movie"
            "OC\\Preview\\OpenDocument"
            "OC\\Preview\\PNG"
            "OC\\Preview\\TIFF"
            "OC\\Preview\\TXT"
            "OC\\Preview\\XBitmap"
          ];
        };
        phpExtraExtensions = all: [
          all.pdlib
          all.bz2
        ];
      };
      nginx.virtualHosts = {
        "${cfg.host}" = lib.mkIf cfg.enableProxy {
          forceSSL = true;
          enableACME = true;
          http2 = true;
          default = true;
          locations = {
            "/".proxyWebsockets = true;
            "~ ^/nextcloud/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|oc[ms]-provider/.+|.+/richdocumentscode/proxy).php(?:$|/)" =
              { };
          };
        };
        "${cfgC.host}" = lib.mkIf cfgC.enableProxy {
          forceSSL = true;
          enableACME = true;
          http2 = true;
          locations = {
            # static files
            "^~ /loleaflet" = {
              proxyPass = cfgC.local;
              extraConfig = commonProxyConfig;
            };
            # WOPI discovery URL
            "^~ /hosting/discovery" = {
              proxyPass = cfgC.local;
              extraConfig = commonProxyConfig;
            };
            # Capabilities
            "^~ /hosting/capabilities" = {
              proxyPass = cfgC.local;
              extraConfig = commonProxyConfig;
            };
            # download, presentation, image upload and websocket
            "~ ^/lool" = {
              proxyPass = cfgC.local;
              extraConfig = commonWebsocketConfig;
            };
            # Admin Console websocket
            "^~ /lool/adminws" = {
              proxyPass = cfgC.local;
              extraConfig = commonWebsocketConfig;
            };
          };
        };

      };
    };
    virtualisation.oci-containers.containers = {
      go-vod = lib.mkIf config.my.servers.go-vod.enable {
        autoStart = true;
        image = "radialapps/go-vod";
        environment = {
          TZ = "America/Mexico_City";
          NEXTCLOUD_HOST = "https://${config.services.nextcloud.hostName}";
          NVIDIA_VISIBLE_DEVICES = "all";
        };
        volumes = [ "ncdata:/var/www/html:ro" ];
        extraOptions = [
          "--device=/dev/dri" # VA-API (omit for NVENC)
        ];
      };
      collabora = lib.mkIf config.my.servers.collabora.enable {
        autoStart = true;
        image = "collabora/code";
        imageFile = pkgs.dockerTools.pullImage {
          imageName = "collabora/code";
          imageDigest = "sha256:aab41379baf5652832e9237fcc06a768096a5a7fccc66cf8bd4fdb06d2cbba7f";
          sha256 = "sha256-M66lynhzaOEFnE15Sy1N6lBbGDxwNw6ap+IUJAvoCLs=";
        };
        ports = [ "9980:9980" ];
        environment = {
          TZ = config.my.timeZone;
          domain = cfg.host;
          aliasgroup1 = "cloud.servidos.lat:443";
          dictionaries = "en_CA en_US es_MX es_ES fr_FR it pt_BR ru";
          extra_params = ''
            --o:ssl.enable=false
            --o:ssl.termination=true
          '';
        };
        extraOptions = [
          "--cap-add"
          "MKNOD"
        ];
      };
    };
    systemd = lib.mkIf config.my.servers.nextcloud.enableCron {
      services = {
        nextcloud-cron.path = [ pkgs.perl ];
        nextcloud-cronjob =
          let
            inherit (inputs.jawz-scripts.packages.x86_64-linux) nextcloud-cronjob;
          in
          {
            description = "Runs various nextcloud-related cronjobs";
            wantedBy = [ "multi-user.target" ];
            path = [
              pkgs.bash
              nextcloud-cronjob
            ];
            serviceConfig = {
              Restart = "on-failure";
              RestartSec = 30;
              ExecStart = "${nextcloud-cronjob}/bin/nextcloud-cronjob";
            };
          };
      };
      timers.nextcloud-cronjob = {
        enable = true;
        description = "Runs various nextcloud-related cronjobs";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*:0/10";
        };
      };
    };
  };
}
