{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.dev.docker.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.dev.docker.enable {
    environment.variables.DOCKER_CONFIG = "\${XDG_CONFIG_HOME}/docker";
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs) dockfmt;
      inherit (pkgs.nodePackages) dockerfile-language-server-nodejs;
    };
  };
}
