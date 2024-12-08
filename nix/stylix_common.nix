{ config, pkgs, ... }:
{
  stylix = {
    enable = true;
    # TODO remove that once it becomes optional (*or* switch to changing wallpaper if supported)
    image = ./5120x2880.png;
    fonts.sizes = {
      applications = 10;
      desktop = 10;
      popups = 10;
      terminal = 10;
    };

    fonts.monospace = {
      name = "FiraCode Nerd Font";
      package = pkgs.fira-code-nerdfont;
    };
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
# base16Scheme = "${pkgs.base16-schemes}/share/themes/github.yaml";
    base16Scheme = {
      system = "base16";
      name = "Kantix  ";
      author = "autra";
      variant = "light";
      palette = {   
        base00 = "ffffff"; # Background
          base01 = "eaeaea"; # Lighter Background
          base02 = "bcbcbc"; # Selection Background
          base03 = "545454"; # Comments/Dimmed Foreground
          base04 = "8c8c8c"; # Darker Foreground
          base05 = "000000"; # Default Foreground
          base06 = "000000"; # Brighter Foreground
          base07 = "000000"; # Lightest Foreground
          base08 = "b21818"; # Red/Error
          base09 = "ec831f"; # Orange/Warning
          base0A = "ec831f"; # Yellow/Highlight
          base0B = "18b218"; # Green/Success
          base0C = "159a9a"; # Cyan/Special
          base0D = "005f87"; # Blue/Information
          base0E = "b218b2"; # Purple/Keywords
          base0F = "ec831f"; # Brown/Deprecated
      };
    };
    cursor = {
      name = "breeze";
      size = 24;
    };
  };
}
