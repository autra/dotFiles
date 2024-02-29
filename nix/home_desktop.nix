{ config, pkgs, ... }:

{
  imports = [ ./home_cli.nix ];

  home.packages = with pkgs; [
    kate
    # desktop utilities
    nextcloud-client
  ];

  home.file = {
    ".local/share/konsole/mine.profile".source = ~/dotFiles/konsole/mine.profile;
    ".local/share/konsole/Kantix.colorscheme".source = ~/dotFiles/konsole/Kantix.colorscheme;
  };
}
