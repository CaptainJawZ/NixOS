{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.emacs.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.emacs.enable {
    home-manager.users.jawz = {
      services.lorri.enable = true;
      programs.bash.shellAliases = {
        edit = "emacsclient -t";
        e = "edit";
      };
    };

    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs.xorg) xwininfo;
      inherit (pkgs)
        #emacs everywhere
        xdotool
        xclip
        wl-clipboard-rs

        fd # modern find, faster searches
        fzf # fuzzy finder! super cool and useful
        ripgrep # modern grep
        tree-sitter # code parsing based on symbols and shit, I do not get it
        graphviz # graphs
        tetex # export pdf
        languagetool # proofreader for English

        # lsps
        yaml-language-server
        markdownlint-cli
        ;
      inherit (pkgs.nodePackages)
        vscode-json-languageserver
        prettier # multi-language linter
        ;
    };
    services.emacs = {
      enable = true;
      package = pkgs.emacsWithDoom {
        doomDir = ../../dotfiles/doom;
        doomLocalDir = "/home/jawz/.local/share/nix-doom";
        tangleArgs = "--all config.org";
        extraPackages =
          epkgs:
          let
            inherit (config.home-manager.users.jawz.programs.emacs)
              extraPackages
              extraConfig
              ;
            extra = extraPackages epkgs;
          in
          extra
          ++ (
            if config.stylix.enable then
              [
                (epkgs.trivialBuild {
                  pname = "stylix-theme";
                  src = pkgs.writeText "stylix-theme.el" extraConfig;
                  version = "0.1.0";
                  packageRequires = extra;
                })
              ]
            else
              [ ]
          );
      };
      defaultEditor = true;
    };
  };
}
