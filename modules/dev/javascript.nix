{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.dev.javascript.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.dev.javascript.enable {
    home-manager.users.jawz.xdg.configFile = {
      "npm/npmrc".text = ''
        user=0
        unsafe-perm=true
        prefix=$XDG_DATA_HOME/npm
        cache=$XDG_CACHE_HOME/npm
        tmp=$XDG_RUNTIME_DIR/npm
        init-module=$XDG_CONFIG_HOME/npm/config/npm-init.js
        store-dir=$XDG_DATA_HOME/pnpm-store
      '';
      "configstore/update-notifier-npm-check.json".text = builtins.toJSON {
        optOut = false;
        lastUpdateCheck = 1646662583446;
      };
    };
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs) nodejs;
      inherit (pkgs.nodePackages) pnpm;
    };
    environment.variables = {
      NPM_CONFIG_USERCONFIG = "\${XDG_CONFIG_HOME}/npm/npmrc";
      PNPM_HOME = "\${XDG_DATA_HOME}/pnpm";
      PATH = [
        "\${XDG_DATA_HOME}/npm/bin"
        "\${XDG_DATA_HOME}/pnpm"
      ];
    };
  };
}
