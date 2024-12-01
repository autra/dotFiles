{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    blender
  ];
}
