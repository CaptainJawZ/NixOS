{ lib, config, ... }:
{
  options.my.servers.paperless.enable = lib.mkEnableOption "enable";
  config = lib.mkIf (config.my.servers.paperless.enable && config.my.servers.postgres.enable) {
    networking.firewall.allowedTCPPorts = [ config.services.paperless.port ];
    services.paperless = {
      enable = true;
      address = "0.0.0.0";
      consumptionDirIsPublic = true;
      consumptionDir = "/srv/pool/scans/";
      settings = {
        PAPERLESS_DBENGINE = "postgress";
        PAPERLESS_DBNAME = "paperless";
        PAPERLESS_DBHOST = config.my.postgresSocket;
        PAPERLESS_TIME_ZONE = config.my.timeZone;
        PAPERLESS_CONSUMER_IGNORE_PATTERN = builtins.toJSON [
          ".DS_STORE/*"
          "desktop.ini"
        ];
        PAPERLESS_OCR_USER_ARGS = builtins.toJSON {
          optimize = 1;
          pdfa_image_compression = "lossless";
        };
      };
    };
  };
}
