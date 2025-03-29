{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my = {
    apps.art.enable = lib.mkEnableOption "enable";
    dev.gameDev.enable = lib.mkEnableOption "enable";
  };
  config = lib.mkIf config.my.apps.art.enable {
    users.users.jawz.packages =
      builtins.attrValues {
        inherit (pkgs)
          eyedropper # color picker
          emulsion-palette # self explanatory
          gimp # the coolest bestest art program to never exist
          krita # art to your heart desire!
          mypaint # not the best art program
          mypaint-brushes # but it's got some
          mypaint-brushes1 # nice damn brushes
          blender # cgi animation and sculpting
          drawpile # arty party with friends!!
          pureref # create inspiration/reference boards
          ;
      }
      ++ (
        if config.my.dev.gameDev.enable then
          builtins.attrValues {
            inherit (pkgs)
              godot_4 # game development
              gdtoolkit_4 # gdscript language server
              ;
          }
        else
          [ ]
      );
  };
}
