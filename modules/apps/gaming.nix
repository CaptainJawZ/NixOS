{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.nix-gaming.nixosModules.platformOptimizations ];
  options.my.apps = {
    gaming.enable = lib.mkEnableOption "enable";
    switch.enable = lib.mkEnableOption "enable";
  };
  config = lib.mkIf config.my.apps.gaming.enable {
    # sops.secrets.switch-presence = lib.mkIf config.my.apps.gaming.switch.enable {
    #   sopsFile = ../../secrets/env.yaml;
    #   format = "dotenv";
    #   owner = config.users.users.jawz.name;
    #   inherit (config.users.users.jawz) group;
    # };
    programs = {
      gamemode.enable = true;
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        platformOptimizations.enable = true;
      };
    };
    services = lib.mkIf config.my.apps.switch.enable {
      switch-boot.enable = true;
      # switch-presence = {
      #   enable = true;
      #   environmentFile = config.sops.secrets.switch-presence.path;
      # };
    };
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        shipwright # zelda OoT port
        mangohud # fps & stats overlay
        lutris # games launcher & emulator hub
        cartridges # games launcher
        gamemode # optimizes linux to have better gaming performance
        heroic # install epic games
        protonup-qt # update proton-ge
        ns-usbloader # load games into my switch
        # emulators
        rpcs3 # ps3
        pcsx2 # ps2
        cemu # wii u
        dolphin-emu # wii
        snes9x-gtk # snes
        ryubing # switch
        torzu # switch
        lime3ds # 3Ds
        prismlauncher # minecraft launcher with jdk overlays
        ;
    };
  };
}
