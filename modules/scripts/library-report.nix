{ inputs, lib, ... }:
{
  imports = [ ./base.nix ];
  config.my.scripts.library-report = {
    enable = lib.mkDefault false;
    install = true;
    service = false;
    name = "library-report";
    package = inputs.jawz-scripts.packages.x86_64-linux.library-report;
  };
}
