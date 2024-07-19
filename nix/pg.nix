{ pkgs, config,...}:
{
  config.services.postgresql = {
    enable = true;
    ensureDatabases = [ config.mine.common.user ];
    ensureUsers = [{ 
      name = config.mine.common.user;
      ensureDBOwnership = true;
      ensureClauses.superuser = true;
    }];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     peer
    '';
  };
}
