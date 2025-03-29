{
  config,
  lib,
  ...
}:
let
  cfg = config.my.websites.portfolio;
  setup = import ./setup.nix { inherit lib config; };
in
{
  options.my.websites.portfolio = setup.mkOptions "portfolio" "portfolio" 0;
  config = {
    services.nginx.virtualHosts."danilo-reyes.com" = lib.mkIf cfg.enableProxy {
      forceSSL = true;
      enableACME = true;
      http2 = true;
      root = "/srv/www/danilo-reyes.com";
      # index = "index.html";
      locations."/".extraConfig = ''
        try_files $uri $uri/ =404;
      '';
    };
  };
}
