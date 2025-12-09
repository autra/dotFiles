{ config, pkgs, lib,... }:
let common = import ../common/common.nix {};
in
rec {
  imports = [ ./cli.nix ];
 
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) common.unfreePkgs;
          
  home.packages = with pkgs; [
    xclip
    # desktop utilities
    libreoffice-qt
    hunspell
    hunspellDicts.fr-moderne
    nextcloud-client
    thunderbird
    signal-desktop
    firefox
    firefox-devedition

    brave
    vlc
    calibre
    gimp
    inkscape
    liferea
    musescore
    keepassxc
    meld
    qgis
    kdePackages.kdenlive
    tlp

    showmethekey
    peek
    zeal
    kdePackages.kamoso
    vscode.fhs
    rustdesk

    # gaming
    playonlinux
    lutris
  ];

  home.file = {
    ".local/share/konsole/mine.profile".source = config.home.homeDirectory + "/dotFiles/konsole/mine.profile";
    ".local/share/konsole/Kantix.colorscheme".source = config.home.homeDirectory + "/dotFiles/konsole/Kantix.colorscheme";
  };

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
      modify_font = "cell_height 97%";
      text_composition_strategy = "1.0 30";
      disable_ligature = "cursor";
    };
    extraConfig = "cursor none";
  };
}
