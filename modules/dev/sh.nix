{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.dev.sh.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.dev.sh.enable {
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        bashdb # autocomplete
        shellcheck # linting
        shfmt # a shell parser and formatter
        ;
      #LSP
      inherit (pkgs.nodePackages) bash-language-server;
    };
  };
}
