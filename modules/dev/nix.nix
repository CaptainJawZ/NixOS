{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.dev.nix.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.dev.nix.enable {
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        nixfmt-rfc-style # formating
        cachix # why spend time compiling?
        nixd # language server
        statix # linter
        ;
    };
  };
}
