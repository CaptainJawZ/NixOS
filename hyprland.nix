{
  pkgs,
  inputs,
  ...
}:
let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &
    sleep 1
    ${pkgs.swww}/bin/swww img ${./wallpaper.jpeg} &
  '';
in
{
  config = {
    home-manager.users.jawz = {
      programs = {
        kitty.enable = true;
      };
      wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        systemd.variables = [ "--all" ];
        settings = {
          exec-once = "${startupScript}/bin/start";
        };
      };
    };
  };
}
