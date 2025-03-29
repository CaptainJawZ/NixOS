{
  emacs.enable = true;
  apps.dictionaries.enable = true;
  # websites.portfolio.enableProxy = true;
  services = {
    network.enable = true;
    # wireguard.enable = true;
  };
  # enableProxy = true;
  shell = {
    tools.enable = true;
    multimedia.enable = true;
  };
  dev = {
    nix.enable = true;
    python.enable = true;
    sh.enable = true;
  };
  scripts.split-dir.enable = true;
  # servers = {
  #   jellyfin = {
  #     enableProxy = true;
  #     hostName = "server";
  #   };
  #   plex = {
  #     enableProxy = true;
  #     hostName = "server";
  #   };
  #   nextcloud = {
  #     enable = true;
  #     enableCron = true;
  #     enableProxy = true;
  #   };
  #   audiobookshelf = {
  #     enable = true;
  #     enableProxy = true;
  #   };
  #   bazarr = {
  #     enableProxy = true;
  #     hostName = "server";
  #   };
  #   collabora = {
  #     enable = true;
  #     enableProxy = true;
  #   };
  #   homepage = {
  #     enable = true;
  #     enableProxy = true;
  #   };
  #   kavita = {
  #     enableProxy = true;
  #     hostName = "server";
  #   };
  #   lidarr = {
  #     enableProxy = true;
  #     hostName = "server";
  #   };
  #   maloja = {
  #     enable = true;
  #     enableProxy = true;
  #   };
  #   mealie = {
  #     enable = true;
  #     enableProxy = true;
  #   };
  #   microbin = {
  #     enable = true;
  #     enableProxy = true;
  #   };
  #   multi-scrobbler = {
  #     enable = true;
  #     enableProxy = true;
  #   };
  #   paperless.enable = true;
  #   postgres.enable = true;
  #   prowlarr = {
  #     enableProxy = true;
  #     hostName = "server";
  #   };
  #   qbittorrent.enable = true;
  #   radarr = {
  #     enableProxy = true;
  #     hostName = "server";
  #   };
  #   ryot = {
  #     enable = true;
  #     enableProxy = true;
  #   };
  #   shiori = {
  #     enable = true;
  #     enableProxy = true;
  #   };
  #   sonarr = {
  #     enableProxy = true;
  #     hostName = "server";
  #   };
  #   vaultwarden = {
  #     enable = true;
  #     enableProxy = true;
  #   };
  #   synapse = {
  #     enable = true;
  #     enableProxy = true;
  #   };
  # };
}
