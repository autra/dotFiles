{ pkgs, config, ... }:
let
  upgrade_script = (
    let
      # XXX specify the postgresql package you'd like to upgrade to.
      # Do not forget to list the extensions you need.
      newPostgres = pkgs.postgresql.withPackages (pp: [
        pp.postgis
      ]);
      cfg = config.services.postgresql;
    in
    pkgs.writeScriptBin "upgrade-pg-cluster" ''
      set -eux
      # XXX it's perhaps advisable to stop all services that depend on postgresql
      systemctl stop postgresql

      export NEWDATA="/var/lib/postgresql/${newPostgres.psqlSchema}"
      export NEWBIN="${newPostgres}/bin"

      export OLDDATA="${cfg.dataDir}"
      export OLDBIN="${cfg.finalPackage}/bin"

      install -d -m 0700 -o postgres -g postgres "$NEWDATA"
      cd "$NEWDATA"
      sudo -u postgres "$NEWBIN/initdb" -D "$NEWDATA" ${pkgs.lib.escapeShellArgs cfg.initdbArgs}

      sudo -u postgres "$NEWBIN/pg_upgrade" \
        --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
        --old-bindir "$OLDBIN" --new-bindir "$NEWBIN" \
        "$@"
    ''
  );
in
{
  config.environment.systemPackages = with pkgs; [
    upgrade_script
    pgadmin4-desktopmode
    dbeaver-bin
    rainfrog
  ];
  config.services.postgresql = {
    enable = true;
    # this is necessary, because otherwise postgresql stays in the version at the time of system.stateVersion
    package = pkgs.postgresql_17;
    extensions = (ps: with ps; [ postgis ]);
    ensureDatabases = [ config.mine.common.user ];
    ensureUsers = [{
      name = config.mine.common.user;
      ensureDBOwnership = true;
      ensureClauses.superuser = true;
    }];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser    address       auth-method
      local all       all                     peer
      host  all       all  127.0.0.1/32  scram-sha-256
      host  all       all  ::1/128       scram-sha-256
    '';
  };
}
