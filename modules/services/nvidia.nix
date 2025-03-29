{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.services.nvidia.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.services.nvidia.enable {
    boot.kernelParams = lib.mkIf (config.networking.hostName == "workstation") [ "nvidia-drm.fbdev=1" ];
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = builtins.attrValues {
          inherit (pkgs)
            nvidia-vaapi-driver
            vaapiVdpau
            libvdpau-va-gl
            vulkan-loader
            mesa
            ;
        };
      };
      nvidia = {
        open = config.networking.hostName == "workstation";
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
      };
    };
  };
}
