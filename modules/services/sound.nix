{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];
  options.my.services.sound.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.services.sound.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true; # make pipewire realtime-capable
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      lowLatency = {
        enable = true;
        quantum = 64;
        rate = 48000;
      };
    };
  };
}
