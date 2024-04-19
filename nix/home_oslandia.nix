# specific for oslandia
{ config, pkgs, ... }:
{
  imports = [ ./home_desktop.nix ];
  # TODO osladoc, oslcli
  home.packages = with pkgs; [
    pass
    qtpass
    timewarrior
  ];
}
