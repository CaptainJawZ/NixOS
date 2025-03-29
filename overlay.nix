{
  mkpkgs,
  inputs,
  ...
}:
let
  pkgs = mkpkgs inputs.nixpkgs;
  pkgs11 = mkpkgs inputs.nixpkgs11;
in
_final: prev: {
  gnome = prev.gnome.overrideScope (
    _final: prev: {
      nautilus = prev.nautilus.overrideAttrs (old: {
        buildInputs =
          old.buildInputs
          ++ builtins.attrValues {
            inherit (pkgs.gst_all_1)
              gst-plugins-good
              gst-plugins-bad
              ;
          };
      });
    }
  );
  lutris = prev.lutris.override {
    extraPkgs =
      pkgs:
      builtins.attrValues {
        inherit (pkgs) pango winetricks;
      }
      ++ (with pkgs; [
        wine64Packages.stable
        wineWowPackages.stable
      ]);
  };
  handbrake = prev.handbrake.override { useGtk = true; };
  discord = prev.discord.override {
    withVencord = true;
    withOpenASAR = true;
  };
  ripgrep = prev.ripgrep.override { withPCRE2 = true; };
  papirus-icon-theme = prev.papirus-icon-theme.override { color = "yellow"; };
  blender = pkgs11.blender.override { cudaSupport = true; };
  inherit (pkgs11)
    torrenttools
    cemu
    open-webui
    lime3ds
    ;
}
