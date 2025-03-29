{
  emacs.enable = true;
  apps.dictionaries.enable = true;
  shell = {
    tools.enable = true;
    multimedia.enable = true;
  };
  services = {
    network.enable = true;
    nvidia.enable = true;
  };
  dev = {
    nix.enable = true;
    python.enable = true;
    sh.enable = true;
  };
  scripts = {
    split-dir.enable = true;
    manage-library.enable = true;
    library-report.enable = true;
  };
  servers = {
    sonarr.enable = true;
    radarr.enable = true;
    lidarr.enable = true;
    prowlarr.enable = true;
    bazarr.enable = true;
    kavita.enable = true;
    qbittorrent.enable = true;
    sabnzbd.enable = true;
    unpackerr.enable = true;
    plex.enable = true;
    jellyfin.enable = true;
  };
}
