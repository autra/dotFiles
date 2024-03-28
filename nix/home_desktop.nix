{ config, pkgs, ... }:

{
  imports = [ ./home_cli.nix ];

  home.packages = with pkgs; [
    xclip
    kate
    # desktop utilities
    nextcloud-client
    thunderbird
    firefox
    vlc
    calibre
    gimp
    inkscape
    shutter
    flameshot
    liferea
    musescore
    keepassxc
    meld
    qgis
    # tlp
    # tlp-rdw
  ];

  home.file = {
    ".local/share/konsole/mine.profile".source = ~/dotFiles/konsole/mine.profile;
    ".local/share/konsole/Kantix.colorscheme".source = ~/dotFiles/konsole/Kantix.colorscheme;
  };
}
