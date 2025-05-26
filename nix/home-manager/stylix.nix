{ config, pkgs, ... }:
{
  imports = [ ../common/stylix.nix ]; 
  stylix = {
    # currently I manage it myself
    targets.starship.enable = false;
  };
}
