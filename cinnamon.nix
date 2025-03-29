{ pkgs, ... }:
{
  services = {
    libinput.enable = true;
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;
    };
  };
  qt = {
    enable = true;
    style = "adwaita";
  };
  users.users.jawz.packages = builtins.attrValues {
    inherit (pkgs)
      adw-gtk3 # theme legacy applications
      papirus-icon-theme # icon theme
      ;
  };
}
