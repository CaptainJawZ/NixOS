{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  services = {
    gvfs.enable = true;
    libinput.enable = true;
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager = {
        gnome.enable = true;
        xterm.enable = lib.mkForce false;
      };
    };
  };
  environment.gnome.excludePackages = builtins.attrValues {
    inherit (pkgs)
      baobab
      cheese
      epiphany
      gnome-characters
      gnome-connections
      gnome-font-viewer
      gnome-photos
      gnome-text-editor
      gnome-tour
      yelp
      gnome-music
      ;
  };
  qt = {
    enable = true;
    style = "adwaita";
  };
  users.users.jawz.packages = builtins.attrValues {
    inherit (pkgs.gnomeExtensions)
      appindicator # applets for open applications
      tactile # window manager
      freon # hardware temperature monitor
      gamemode-shell-extension # I guess I'm a gamer now?
      burn-my-windows # special effects for when closing windows
      ;
    inherit (inputs.jawz-scripts.packages.x86_64-linux)
      pano
      ;
  };
}
