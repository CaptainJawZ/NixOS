{ inputs, lib, ... }:
{
  imports = [ ./base.nix ];
  config.my.scripts.manage-library = {
    enable = lib.mkDefault false;
    install = true;
    service = true;
    name = "manage-library";
    timer = "00:30";
    description = "scans the library directory and sorts files";
    package = inputs.jawz-scripts.packages.x86_64-linux.manage-library;
  };
}
