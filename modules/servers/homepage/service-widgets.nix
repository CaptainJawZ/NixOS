{ lib, config, ... }:
{
  calendar.widget = {
    type = "calendar";
    firstDayInWeek = "sunday";
    view = "monthly";
    maxEvents = 10;
    showTime = true;
    timezone = "America/Mexico_City";
    integrations =
      let
        createIntegration = name: color: {
          inherit color;
          type = name;
          service_group = "multimedia";
          service_name = name;
          params.unmonitored = true;
        };
      in
      [
        (createIntegration "sonarr" "teal")
        (createIntegration "radarr" "amber")
        (createIntegration "lidarr" "lime")
        {
          type = "ical";
          url = "https://cloud.servidos.lat/remote.php/dav/public-calendars/QLfA37F4dA2q4Way?export";
          name = "chores";
          color = "yellow";
          params.showName = true;
        }
        {
          type = "ical";
          url = "https://cloud.servidos.lat/remote.php/dav/public-calendars/8jbXjTKrYqoqHk7M?export";
          name = "personal";
          color = "blue";
          params.showName = true;
        }
        {
          type = "ical";
          url = "https://cloud.servidos.lat/remote.php/dav/public-calendars/3zdXGggc6P4JF4WB?export";
          name = "health";
          color = "yellow";
          params.showName = true;
        }
      ];
  };
  audiobookshelf =
    let
      cfg = config.my.servers.audiobookshelf;
    in
    lib.mkIf (cfg.enable || cfg.enableProxy) {
      icon = "${cfg.name}.png";
      href = cfg.url;
      widget = {
        url = cfg.local;
        type = cfg.name;
        key = "{{HOMEPAGE_VAR_AUDIOBOOKSHELF}}";
      };
    };
  plex =
    let
      cfg = config.my.servers.plex;
    in
    lib.mkIf (cfg.enable || cfg.enableProxy) {
      icon = "${cfg.name}.png";
      href = cfg.url;
      widget = {
        url = cfg.local;
        type = cfg.name;
        key = "{{HOMEPAGE_VAR_PLEX}}";
      };
    };
  jellyfin =
    let
      cfg = config.my.servers.jellyfin;
    in
    lib.mkIf (cfg.enable || cfg.enableProxy) {
      icon = "${cfg.name}.png";
      href = cfg.url;
      widget = {
        url = cfg.local;
        type = cfg.name;
        key = "{{HOMEPAGE_VAR_JELLYFIN}}";
        enableUser = true;
        enableBlocks = true;
        enableNowPlaying = false;
      };
    };
  sonarr =
    let
      cfg = config.my.servers.sonarr;
    in
    lib.mkIf (cfg.enable || cfg.enableProxy) {
      icon = "${cfg.name}.png";
      href = cfg.url;
      widget = {
        url = cfg.local;
        type = cfg.name;
        key = "{{HOMEPAGE_VAR_SONARR}}";
        enableQueue = true;
      };
    };
  radarr =
    let
      cfg = config.my.servers.radarr;
    in
    lib.mkIf (cfg.enable || cfg.enableProxy) {
      icon = "${cfg.name}.png";
      href = cfg.url;
      widget = {
        url = cfg.local;
        type = cfg.name;
        key = "{{HOMEPAGE_VAR_RADARR}}";
        enableQueue = true;
      };
    };
  lidarr =
    let
      cfg = config.my.servers.lidarr;
    in
    lib.mkIf (cfg.enable || cfg.enableProxy) {
      icon = "${cfg.name}.png";
      href = cfg.url;
      widget = {
        url = cfg.local;
        type = cfg.name;
        key = "{{HOMEPAGE_VAR_LIDARR}}";
      };
    };
  prowlarr =
    let
      cfg = config.my.servers.prowlarr;
    in
    lib.mkIf (cfg.enable || cfg.enableProxy) {
      icon = "${cfg.name}.png";
      href = cfg.url;
      widget = {
        type = cfg.name;
        url = cfg.local;
        key = "{{HOMEPAGE_VAR_PROWLARR}}";
      };
    };
  bazarr =
    let
      cfg = config.my.servers.bazarr;
    in
    lib.mkIf (cfg.enable || cfg.enableProxy) {
      icon = "${cfg.name}.png";
      href = cfg.url;
      widget = {
        type = cfg.name;
        url = cfg.local;
        key = "{{HOMEPAGE_VAR_BAZARR}}";
      };
    };
  kavita =
    let
      cfg = config.my.servers.kavita;
    in
    lib.mkIf (cfg.enable || cfg.enableProxy) {
      icon = "${cfg.name}.png";
      href = cfg.url;
      widget = {
        type = cfg.name;
        url = cfg.local;
        username = "{{HOMEPAGE_VAR_KAVITA_USERNAME}}";
        password = "{{HOMEPAGE_VAR_KAVITA_PASSWORD}}";
      };
    };
  "qbittorrent server" =
    let
      url = "https://${config.my.ips.server}:${toString config.my.servers.qbittorrent.port}";
      name = "qbittorrent";
    in
    lib.mkIf config.my.servers.qbittorrent.enable {
      icon = "${name}.png";
      href = url;
      widget = {
        type = name;
        inherit url;
        username = "{{HOMEPAGE_VAR_QBIT_USERNAME}}";
        password = "{{HOMEPAGE_VAR_QBIT_PASSWORD}}";
      };
    };
  "qbittorrent miniserver" =
    let
      url = "https://${config.my.ips.miniserver}:${toString config.my.servers.qbittorrent.port}";
      name = "qbittorrent";
    in
    lib.mkIf config.my.servers.qbittorrent.enable {
      icon = "${name}.png";
      href = url;
      widget = {
        type = name;
        inherit url;
        username = "{{HOMEPAGE_VAR_QBIT_USERNAME}}";
        password = "{{HOMEPAGE_VAR_QBIT_PASSWORD}}";
      };
    };
  sabnzbd =
    let
      name = "sabnzbd";
      url = "https://${config.my.ips.server}:${toString config.my.servers.sabnzbd.port}";
    in
    {
      icon = "${name}.png";
      href = url;
      widget = {
        type = name;
        inherit url;
        key = "{{HOMEPAGE_VAR_SABNZBD}}";
      };
    };
  mealie =
    let
      cfg = config.my.servers.mealie;
    in
    lib.mkIf (cfg.enable || cfg.enableProxy) {
      icon = "${cfg.name}.png";
      href = cfg.url;
      widget = {
        url = cfg.local;
        type = cfg.name;
        key = "{{HOMEPAGE_VAR_MEALIE}}";
        version = 2;
      };
    };
  nextcloud =
    let
      cfg = config.my.servers.nextcloud;
    in
    lib.mkIf (cfg.enable || cfg.enableProxy) {
      icon = "${cfg.name}.png";
      href = cfg.url;
      widget = {
        url = "https://127.0.0.1";
        type = cfg.name;
        username = "{{HOMEPAGE_VAR_NEXTCLOUD_USERNAME}}";
        password = "{{HOMEPAGE_VAR_NEXTCLOUD_PASSWORD}}";
        token = "{{HOMEPAGE_VAR_NEXTCLOUD_TOKEN}}";
        fields = [
          "memoryusage"
          "activeusers"
          "numfiles"
          "numshares"
        ];
      };
    };
  paperless =
    let
      name = "paperlessngx";
      url = "http://${config.my.ips.miniserver}:${toString config.services.paperless.port}";
    in
    lib.mkIf config.my.servers.paperless.enable {
      icon = "paperless.png";
      href = url;
      widget = {
        type = name;
        key = "{{HOMEPAGE_VAR_PAPERLESS}}";
        inherit url;
        fields = [
          "total"
          "inbox"
        ];
      };
    };
}
