{ config, pkgs, ... }:
{
  stylix = {
    enable = true;
    fonts.sizes = {
      applications = 10;
      desktop = 10;
      popups = 10;
      terminal = 10;
    };

    fonts.monospace = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
    };
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
# base16Scheme = "${pkgs.base16-schemes}/share/themes/github.yaml";
    # https://coolors.co/005f87-2a9d8f-17b36f-8ab17d-e2b33c-ec831f-c21111-b31765
    # ["005f87","2a9d8f","17b36f","8ab17d","e2b33c","ec831f","c21111","b31765"]
    # chatgpt is able to convert that into konsole colorscheme with a bit of persuasion
    base16Scheme = {
      system = "base16";
      name = "Kantix  ";
      author = "autra";
      variant = "light";
      palette = {   
        base00 = "ffffff"; # #ffffff # Background
        base01 = "eaeaea"; # #eaeaea # Lighter Background
        base02 = "bcbcbc"; # #bcbcbc # Selection Background
        base03 = "797979"; # #545454 # Comments/Dimmed Foreground
        base04 = "484848"; # #000000 # Darker Foreground
        base05 = "181818"; # #181818 # Default Foreground
        base06 = "4b4b4b"; # #4b4b4b # Brighter Foreground
        base07 = "8c8c8c"; # #8c8c8c # Lightest Foreground
        base08 = "c21111"; # #C21111 #C3123E #b22d3a # Red/Error
        base09 = "d5a804"; # #d5a804 # Orange/Warning
        base0A = "ec831f"; # #EC831F #ec831f # Yellow/Highlight
        base0B = "17b36f"; # #17B36F #8AB17D #18b249 # Green/Success
        base0C = "2A9D8F"; # #2a9d8f #159a9a # Cyan/Special
        base0D = "005F87"; # #264653 #005f87 # Blue/Information
        base0E = "B31765"; # #b31765 #b218b2 # Purple/Keywords
        base0F = "aa5e16"; # #e2b33c #aa5e16 # Brown/Deprecated
      };
    };
    cursor = {
      name = "breeze";
      size = 24;
      package = pkgs.kdePackages.breeze;
    };
  };
}
