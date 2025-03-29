{ inputs, lib, ... }:
{
  imports = [ ./base.nix ];
  config.my.scripts.tasks = {
    enable = lib.mkDefault false;
    install = true;
    service = true;
    name = "tasks";
    timer = "*:0/10";
    description = "Runs a bunch of organizing tasks on selected directories";
    package = inputs.jawz-scripts.packages.x86_64-linux.tasks;
  };
}
