{ config, pkgs, ... }:
{
  imports = [ ../common/stylix.nix ];
  # I use custom plymouth theme
  stylix.targets.plymouth.enable = false;
}
