{ config, pkgs, ... }:

rec {
  home.homeDirectory = "/home/augustin";
  imports = [ ./home_cli.nix ];

  home.packages = with pkgs; [
    xclip
    kate
    # desktop utilities
    libreoffice
    onlyoffice-bin
    nextcloud-client
    thunderbird
    firefox
    firefox-devedition-bin
#     (firefox-devedition-bin.overrideAttrs (e: {
#       desktopItem = e.desktopItem // {
#         # actions.new-window.exec = "${launcherName} -P 1q8jo0jp.dev-edition-fixed --new-window %U";
#         actions = "foo";
#       };

# # Update the install script to use the new .desktop entry
#       buildCommand = builtins.replaceStrings [ "${e.desktopItem}" ] [ "${desktopItem}" ] e.buildCommand;
#     })) 
    brave
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
    openshot-qt
    libsForQt5.kdenlive
    tlp
    # tlp-rdw
    # pinentry-qt

    screenkey
    peek
    zeal
  ];

  home.file = {
    ".local/share/konsole/mine.profile".source = home.homeDirectory + "/dotFiles/konsole/mine.profile";
    ".local/share/konsole/Kantix.colorscheme".source = home.homeDirectory + "/dotFiles/konsole/Kantix.colorscheme";
  };
}
