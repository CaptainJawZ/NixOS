{ pkgs, ... }:
{
  stylix = {
    enable = true;
    image = ./wallpapers/pirates.jpg;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 30;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.comic-shanns-mono;
        name = "ComicShansMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };
  };
  home-manager.users.jawz.stylix = {
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      light = "Papirus-Light";
      dark = "Papirus-Dark";
    };
  };
}
