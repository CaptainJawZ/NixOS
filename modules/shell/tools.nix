{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  options.my.shell.tools.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.shell.tools.enable {
    home-manager.users.jawz = {
      programs = {
        hstr.enable = true;
        htop = {
          enable = true;
          package = pkgs.htop-vim;
        };
        zoxide = {
          enable = true;
          enableBashIntegration = true;
        };
        bash = {
          initExtra = ''
            if command -v fzf-share >/dev/null; then
            source "$(fzf-share)/key-bindings.bash"
            source "$(fzf-share)/completion.bash"
            fi
          '';
          shellAliases = {
            cd = "z";
            hh = "hstr";
            ls = "eza --icons --group-directories-first";
            rm = "trash";
            b = "bat";
            f = "fzf --multi --exact -i";
            unique-extensions = ''
              fd -tf | rev | cut -d. -f1 | rev |
              tr '[:upper:]' '[:lower:]' | sort |
              uniq --count | sort -rn'';
          };
        };
        bat = {
          enable = true;
          config.pager = "less -FR";
          extraPackages = builtins.attrValues {
            inherit (pkgs.bat-extras)
              batman # man pages
              batpipe # piping
              batgrep # ripgrep
              batdiff # this is getting crazy!
              batwatch # probably my next best friend
              prettybat # trans your sourcecode!
              ;
          };
        };
      };
    };
    programs = {
      starship.enable = true;
      tmux.enable = true;
      fzf.fuzzyCompletion = true;
      neovim = {
        enable = true;
        vimAlias = true;
      };
    };
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        ripgrep # modern grep
        du-dust # rusty du similar to gdu
        eza # like ls but with colors
        fd # modern find, faster searches
        fzf # fuzzy finder! super cool and useful
        gdu # disk-space utility checker, somewhat useful
        tldr # man for retards
        trash-cli # oop! did not meant to delete that
        jq # linting
        smartmontools # check hard drie health
        ;
      inherit (inputs.jawz-scripts.packages.x86_64-linux)
        rmlint # amazing dupe finder that integrates well with BTRFS
        ;
    };
    environment.variables = {
      HISTFILE = "\${XDG_STATE_HOME}/bash/history";
      LESSHISTFILE = "-";
      RIPGREP_CONFIG_PATH = "\${XDG_CONFIG_HOME}/ripgrep/ripgreprc";
    };
  };
}
