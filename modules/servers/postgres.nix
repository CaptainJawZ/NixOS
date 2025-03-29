{
  config,
  lib,
  pkgs,
  ...
}:
let
  upgrade-pg-cluster =
    let
      newPostgres = pkgs.postgresql_16.withPackages (_pp: [ ]);
    in
    pkgs.writeScriptBin "upgrade-pg-cluster" ''
      set -eux
      systemctl stop postgresql
      export NEWDATA="/var/lib/postgresql/${newPostgres.psqlSchema}"
      export NEWBIN="${newPostgres}/bin"
      export OLDDATA="${config.services.postgresql.dataDir}"
      export OLDBIN="${config.services.postgresql.package}/bin"
      install -d -m 0700 -o postgres -g postgres "$NEWDATA"
      cd "$NEWDATA"
      sudo -u postgres $NEWBIN/initdb -D "$NEWDATA"
      sudo -u postgres $NEWBIN/pg_upgrade \
        --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
        --old-bindir $OLDBIN --new-bindir $NEWBIN \
        "$@"
    '';
  dbNames = [
    "jawz"
    "paperless"
    "nextcloud"
    "ryot"
    "vaultwarden"
    "shiori"
    "mealie"
    "firefly-iii"
    "matrix-synapse"
  ];
in
{
  options.my.servers.postgres.enable = lib.mkEnableOption "enable";
  config = lib.mkIf config.my.servers.postgres.enable {
    environment.systemPackages = [ upgrade-pg-cluster ];
    services.postgresql = {
      enable = true;
      ensureDatabases = dbNames;
      package = pkgs.postgresql_16;
      ensureUsers = map (name: {
        inherit name;
        ensureDBOwnership = true;
      }) dbNames;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all              trust
        host  all all ${config.my.localhost}/32 trust
        host  all all ::1/128      trust
      '';
    };
  };
}
