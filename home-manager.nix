{
  inputs,
  config,
  pkgs,
  ...
}:
{
  home.stateVersion = "24.11";
  programs.bash =
    let
      inherit (pkgs) fd fzf;
      inherit (inputs.jawz-scripts.packages.x86_64-linux) pokemon-colorscripts;
    in
    {
      enable = true;
      historyFile = "\${XDG_STATE_HOME}/bash/history";
      historyControl = [
        "erasedups"
        "ignorespace"
        "ignoredups"
      ];
      shellAliases = {
        cp = "cp -i";
        mv = "mv -i";
        mkdir = "mkdir -p";
        ".." = "cd ..";
        "..." = "cd ../..";
        ".3" = "cd ../../..";
        ".4" = "cd ../../../..";
        ".5" = "cd ../../../../..";
        c = "cat";
        sc = "systemctl --user";
        jc = "journalctl --user -xefu";
      };
      enableVteIntegration = true;
      initExtra = ''
        ${pokemon-colorscripts}/bin/pokemon-colorscripts -r --no-title
        export command_timeout=60
      '';
    };
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = false;
      desktop = "${config.home.homeDirectory}";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      templates = "${config.xdg.dataHome}/Templates";
      videos = "${config.home.homeDirectory}/Videos";
    };
    configFile.wgetrc.text = "hsts-file=\${XDG_CACHE_HOME}/wget-hsts";
  };
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = "Danilo Reyes";
      userEmail = "CaptainJawZ@protonmail.com";
    };
  };
}
