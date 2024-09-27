{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    meshlab
    paraview
    blender
  ];
}
