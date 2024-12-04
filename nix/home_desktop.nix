{ config, pkgs, lib,... }:

rec {
  home.homeDirectory = "/home/augustin";
  imports = [ ./home_cli.nix ];
 
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "code"
    "libsciter"
  ];
          
  home.packages = with pkgs; [
    xclip
    kate
    # desktop utilities
    libreoffice
    nextcloud-client
    thunderbird
    signal-desktop
    firefox
    firefox-devedition-bin

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

    showmethekey
    peek
    zeal
    libsForQt5.kamoso
    github-desktop
    vscode.fhs
    obs-studio
    rustdesk
  ];

  home.file = {
    ".local/share/konsole/mine.profile".source = home.homeDirectory + "/dotFiles/konsole/mine.profile";
    ".local/share/konsole/Kantix.colorscheme".source = home.homeDirectory + "/dotFiles/konsole/Kantix.colorscheme";
  };

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
    };
  };
}
