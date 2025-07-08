{ pkgs, config,...}:
{
  imports = [ ../common/common.nix ];
  config.environment.systemPackages = with pkgs; [
    pgadmin
    dbeaver-bin
    rainfrog
  ];
  config.services.postgresql = {
    enable = true;
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
