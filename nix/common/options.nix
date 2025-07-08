{ config, lib, pkgs, ... }:
{
  options = {
    mine.common.user = lib.mkOption	{
      type = lib.types.str;
      default = "augustin";
      example = "augustin";
      description = "The user to configure for this system";
    };
  };

}
