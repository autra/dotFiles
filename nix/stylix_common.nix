{ config, pkgs, ... }:
{
  stylix = {
    enable = true;
    # TODO remove that once it becomes optional (*or* switch to changing wallpaper if supported)
    image = ./5120x2880.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
# base16Scheme = "${pkgs.base16-schemes}/share/themes/github.yaml";
    # base16Scheme = {
    #   system = "base16";
    #   name = "Github";
    #   author = "Defman21";
    #   variant = "light";
    #   palette = {
    #     base00 = "ffffff";
    #     base01 = "f5f5f5";
    #     base02 = "c8c8fa";
    #     base03 = "969896";
    #     base04 = "e8e8e8";
    #     base05 = "333333";
    #     base06 = "ffffff";
    #     base07 = "ffffff";
    #     base08 = "ed6a43";
    #     base09 = "0086b3";
    #     base0A = "795da3";
    #     base0B = "183691";
    #     base0C = "183691";
    #     base0D = "795da3";
    #     base0E = "a71d5d";
    #     base0F = "333333";
    #   };
    # };
    cursor = {
      name = "breeze";
      size = 24;
    };
  };
}
