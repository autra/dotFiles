{ config, pkgs, ... }:

rec {
  home.homeDirectory = "/home/augustin";
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
    ".local/share/konsole/mine.profile".source = home.homeDirectory + "/dotFiles/konsole/mine.profile";
    ".local/share/konsole/Kantix.colorscheme".source = home.homeDirectory + "/dotFiles/konsole/Kantix.colorscheme";
  };
}
