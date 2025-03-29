{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.dev.haskell.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.dev.haskell.enable {
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        haskell-language-server # LSP server for Haskell
        cabal-install # Standard Haskell build tool
        hlint # Linter for Haskell source code
        ;
      inherit (pkgs.haskellPackages)
        hoogle # Haskell API search engine
        ;
    };
    environment.variables = {
      CABAL_DIR = "\${XDG_CACHE_HOME}/cabal";
      STACK_ROOT = "\${XDG_DATA_HOME}/stack";
      GHCUP_USE_XDG_DIRS = "true";
    };
  };
}
