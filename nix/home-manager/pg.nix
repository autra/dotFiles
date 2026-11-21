# pg config for home-manager
{ config, pkgs, unstable-pkgs, ... }:
{
  home.packages = with pkgs; [
    # broken on pkgs on 26.05, too lazy to fix it there 1 week before the release
    unstable-pkgs.pgadmin4-desktopmode
    dbeaver-bin
    rainfrog
  ];
}
