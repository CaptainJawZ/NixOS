{ inputs, lib, ... }:
{
  imports = [ ./base.nix ];
  config.my.scripts.split-dir = {
    enable = lib.mkDefault false;
    install = true;
    service = false;
    name = "split-dir";
    package = inputs.jawz-scripts.packages.x86_64-linux.split-dir;
  };
}
