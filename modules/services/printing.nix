{
  config,
  lib,
  pkgs,
  ...
}:
let
  printingDrivers = [
    pkgs.hplip
    pkgs.hplipWithPlugin
  ];
in
{
  options.my.services.printing.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.services.printing.enable {
    users.users.jawz.packages = [ pkgs.simple-scan ];
    services.printing = {
      enable = true;
      drivers = printingDrivers;
    };
    hardware.sane = {
      enable = true;
      extraBackends = printingDrivers;
    };
  };
}
