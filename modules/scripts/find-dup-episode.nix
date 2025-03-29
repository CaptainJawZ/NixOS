{ inputs, lib, ... }:
{
  imports = [ ./base.nix ];
  config.my.scripts.find-dup-episodes = {
    enable = lib.mkDefault false;
    install = true;
    service = false;
    name = "find-dup-episodes";
    package = inputs.jawz-scripts.packages.x86_64-linux.find-dup-episodes;
  };
}
