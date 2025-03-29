{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.dev.rust.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.dev.rust.enable {
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        cargo # Rust package manager
        rust-analyzer # Language server for Rust
        clippy # Linter for Rust
        rustfmt # Formatter for Rust code
        ;
    };
  };
}
