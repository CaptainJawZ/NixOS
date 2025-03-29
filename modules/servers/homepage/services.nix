{ lib, config, ... }:
let
  services = import ./service-widgets.nix { inherit lib config; };
in
[
  {
    multimedia = [
      { inherit (services) plex; }
      { inherit (services) jellyfin; }
      { inherit (services) audiobookshelf; }
      { inherit (services) kavita; }
    ];
  }
  {
    piracy = [
      { inherit (services) sonarr; }
      { inherit (services) radarr; }
      { inherit (services) lidarr; }
      { inherit (services) bazarr; }
      { inherit (services) prowlarr; }
      { inherit (services) sabnzbd; }
      { inherit (services) "qbittorrent server"; }
      { inherit (services) "qbittorrent miniserver"; }
    ];
  }
  {
    main = [
      { inherit (services) nextcloud; }
      { inherit (services) mealie; }
      { inherit (services) paperless; }
    ];
  }
]
