{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.apps.fonts.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.apps.fonts.enable {
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        symbola
        comic-neue
        cascadia-code
        ;
      inherit (pkgs.nerd-fonts)
        caskaydia-cove
        open-dyslexic
        comic-shanns-mono
        iosevka
        agave
        ;
    };
  };
}
